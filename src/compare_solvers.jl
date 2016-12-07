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
      stats[Symbol(option)] = solve_problems(solver, probs; merge(bmark_args, option)...)
  end
  profiles = profile_solvers(stats, title=string(solver))
  return stats, profiles
end
