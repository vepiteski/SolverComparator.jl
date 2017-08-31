
#
# Regroup results solver by solver
#

# Benchmark solvers with different options on a set of problems
function compare_solvers_with_options(solvers, options, labels, probs, n_min, n_max; kwargs...)
  bmark_args = Dict{Symbol, Any}(:skipif => model -> (model.meta.ncon > 0)
                                                  || (model.meta.nvar < n_min)
                                                  || (model.meta.nvar > n_max))
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

#
# Version 2 regroup results problem by problem
#

function solve_problem2(solver :: Function, nlp :: AbstractNLPModel, label :: String; kwargs...)
    # Like solve_problem, but with label of method and returns f, g, Hv, H, time
    args = Dict(kwargs)
    skip = haskey(args, :skipif) ? pop!(args, :skipif) : x -> false
    skip(nlp) && throw(SkipException())

    # Julia nonsense
    optimal = false
    f = 0.0
    gNorm = 0.0
    status = "fail"
    iter = 0
    elapsed_time = 0.0
    h_f = 0
    h_g = 0
    h_h = 0
    try
        tic()
        (x, f, gNorm, iter, optimal, tired, status) = solver(nlp; args...)
        elapsed_time = toq()
    catch e
        #  println(e)
        try status = e.msg
        catch
            println("Untraced exception")
            (x, f, gNorm, iter, optimal, tired, status) = solver(nlp; args...)
        end
    end
    @printf("%-35s  %9.2e  %7.1e  %5d  %5d  %6d  %6d  %6d    %10.5f   %s\n",
            label, f, gNorm,
            nlp.counters.neval_obj, nlp.counters.neval_grad,
            nlp.counters.neval_hprod, nlp.counters.neval_hess, iter, elapsed_time, status)
    return optimal ? (nlp.counters.neval_obj, nlp.counters.neval_grad, nlp.counters.neval_hprod, nlp.counters.neval_hess,  elapsed_time) : (-nlp.counters.neval_obj, -nlp.counters.neval_grad, -nlp.counters.neval_hprod, -nlp.counters.neval_hess, -max(elapsed_time,Inf))
end



# Benchmark solvers with different options on a set of problems
function compare_solvers_with_options2(solvers, options, labels, probs, n_min, n_max; printskip :: Bool = false, kwargs...)
    bmark_args = Dict{Symbol, Any}(:skipif => model -> (!unconstrained(model))
                                   || (model.meta.nvar < n_min)
                                   || (model.meta.nvar > n_max))
    skip = model -> (!unconstrained(model)) || (model.meta.nvar < n_min) || (model.meta.nvar > n_max)

    args = Dict(kwargs)

    stats = Dict{Symbol, Array{Int,2}}()
    time = Dict{Symbol, Array{Float64,1}}()

    nprobs = length(probs)

    for label in labels
        stats[Symbol(label)] = -ones(nprobs, 4)
        time[Symbol(label)] = -ones(nprobs)
    end

    k = 0
    for problem in probs
        if !skip(problem)
            x0 = problem.meta.x0
            H = hess(problem,x0)
            f = obj(problem,x0)
            normg = norm(grad(problem,x0))
            nnzH = nnz(H)
            nvar = problem.meta.nvar

            @printf("\nsolving  %-15s  dimension: %8d normg: %10.3e  nnzH:  %8d  Hdensity  %5f\n\n", problem.meta.name, nvar, normg, nnzH, float(2*nnzH)/float(nvar*(nvar+1)))
            k += 1
            @printf("solver                                  f       ||∇f||      #f     #g      #Hv     #H    #iter       time    status\n\n")
            for (solver,option,label) in zip(solvers,options,labels)
                reset!(problem)
                (f, g, hv, h, t) =  solve_problem2(solver, problem, label; merge(bmark_args, option)...)
                stats[Symbol(label)][k,:] = [f, g, hv, h]
                time[Symbol(label)][k] = t
            end
        elseif  printskip
            @printf("%-15s  %8d   ncons = %-8d  %13s   skipped\n",problem.meta.name, problem.meta.nvar, problem.meta.ncon, unconstrained(problem.meta) ? "unconstrained" : "constrained")
        end
        finalize(problem)
    end

    for label in labels
        stats[Symbol(label)] = stats[Symbol(label)][1:k,:]
        time[Symbol(label)] = time[Symbol(label)][1:k]
    end

    args = Dict(kwargs)
    args[:title] = " f + g + H*v + H evaluations"
    profiles = profile_solvers(stats; args...)

    args[:title] = " CPU time"
    profiles_time = profile_solvers2(time; args...)
    return stats, profiles, time, profiles_time
    return stats, profiles, time, profiles_time
end


if Pkg.installed("BenchmarkProfiles") != nothing
  using BenchmarkProfiles

  """
      profile_solvers2(time :: Dict{Symbol, Float64}; title :: String="")

  Plot a performance profile from solver statistics.

  #### Arguments
  * `time`: a dict of time such as obtained from `compare_solvers_with_options2()`

  #### Keyword arguments
  Any keyword argument accepted by `BenchmarkProfiles.performance_profile()`.

  #### Return value
  A profile as returned by `performance_profile()`.
  """
  function profile_solvers2(time :: Dict{Symbol, Array{Float64,1}}; kwargs...)
    args = Dict(kwargs)
    if haskey(args, :title)
      args[:title] *= @sprintf(" (%d problems)", size(time[first(keys(time))], 1))
    end
    performance_profile(hcat([p for p in values(time)]...),
                        collect(String, [string(s) for s in keys(time)]); args...)
  end
end


############################################################################################
# Old versions.

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
