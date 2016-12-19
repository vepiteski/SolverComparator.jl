# benchmark solvers on a set of problems

function compare_solvers(solvers,probs,n_min,n_max;title:: String = " ", kwargs...)
  bmark_args = Dict{Symbol, Any}(:skipif => model -> (model.meta.ncon > 0) 
                                                  || (model.meta.nvar < n_min)
                                                  || (model.meta.nvar > n_max), 
                                 :max_f => 20000)
  profile_args = Dict{Symbol, Any}(:title => title)
  stats, profiles = bmark_and_profile(solvers, probs,
                                      bmark_args=bmark_args, profile_args=profile_args)
  return stats, profiles
end

# Benchmark one solver with different options on a set of problems
function compare_solver_options(solver :: Function, options, probs, n_min, n_max; kwargs...)
  bmark_args = Dict{Symbol, Any}(:skipif => model -> (model.meta.ncon > 0) 
                                                  || (model.meta.nvar < n_min)
                                                  || (model.meta.nvar > n_max), 
                                 :max_eval => 20000)
  stats = Dict{Symbol, Array{Int,2}}()
  for option in options
      @printf("\n\n\n running %s\n\n", string(option))
      stats[Symbol(option)] = solve_problems(solver, probs; merge(bmark_args, option)...)
  end
  profiles = profile_solvers(stats, title=string(solver))
  return stats, profiles
end
 
# Benchmark one solver with different options on a set of problems
function compare_solvers_with_options(solvers, options, labels, probs, n_min, n_max; kwargs...)
  bmark_args = Dict{Symbol, Any}(:skipif => model -> (model.meta.ncon > 0) 
                                                  || (model.meta.nvar < n_min)
                                                  || (model.meta.nvar > n_max), 
                                 :max_eval => 20000)
  stats = Dict{Symbol, Array{Int,2}}()
  for (solver,option,label) in zip(solvers,options,labels)
      @printf("\n\n\n running  %s with  %s\n\n", string(solver),string(option))
      stats[Symbol(label)] = solve_problems(solver, probs; merge(bmark_args, option)...)
  end
  profiles = profile_solvers(stats)
  return stats, profiles
end





type SkipException <: Exception
end


function solve_problem2(solver :: Function, nlp :: AbstractNLPModel, label :: String; kwargs...)
  args = Dict(kwargs)
  skip = haskey(args, :skipif) ? pop!(args, :skipif) : x -> false
  skip(nlp) && throw(SkipException())

  # Julia nonsense
  optimal = false
  f = 0.0
  gNorm = 0.0
  status = "fail"
  try
    (x, f, gNorm, iter, optimal, tired, status) = solver(nlp; args...)
  catch e
  #  println(e)
    try status = e.msg
        catch 
        println("Untraced exception")
        (x, f, gNorm, iter, optimal, tired, status) = solver(nlp; args...)
    end
  end
  # if nlp.scale_obj
  #   f /= nlp.scale_obj_factor
  #   gNorm /= nlp.scale_obj_factor
  # end
  @printf("%-25s  %9.2e  %7.1e  %5d  %5d  %6d  %s\n",
          label, f, gNorm,
          nlp.counters.neval_obj, nlp.counters.neval_grad,
          nlp.counters.neval_hprod, status)
  return optimal ? (nlp.counters.neval_obj, nlp.counters.neval_grad, nlp.counters.neval_hprod) : (-nlp.counters.neval_obj, -nlp.counters.neval_grad, -nlp.counters.neval_hprod)
end



# Benchmark one solver with different options on a set of problems
function compare_solvers_with_options2(solvers, options, labels, probs, n_min, n_max; printskip :: Bool = false, kwargs...)
    bmark_args = Dict{Symbol, Any}(:skipif => model -> (!unconstrained(model)) 
                                   || (model.meta.nvar < n_min)
                                   || (model.meta.nvar > n_max), 
                                   :max_eval => 20000)
    skip = haskey(bmark_args, :skipif) ? pop!(bmark_args, :skipif) : x -> false
    
    stats = Dict{Symbol, Array{Int,2}}()

    nprobs = length(probs)

    for label in labels
        stats[Symbol(label)] = -ones(nprobs, 3)
    end
    
    k = 0
    for problem in probs
        if !skip(problem)
            @printf("\n\n\n solving  %-15s  dimension: %8d \n\n", problem.meta.name, problem.meta.nvar)
            k += 1
            for (solver,option,label) in zip(solvers,options,labels)
                (f, g, h) =  solve_problem2(solver, problem, label; merge(bmark_args, option)...)
                reset!(problem)
                stats[Symbol(label)][k,:] = [f, g, h]
            end
        elseif  printskip 
            @printf("%-15s  %8d   ncons = %-8d  %13s   skipped\n",problem.meta.name, problem.meta.nvar, problem.meta.ncon, unconstrained(problem.meta) ? "unconstrained" : "constrained")
        end
        finalize(problem)
    end

    for label in labels
        stats[Symbol(label)] = stats[Symbol(label)][1:k,:]
    end

    profiles = profile_solvers(stats)
    return stats, profiles
end

