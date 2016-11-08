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

