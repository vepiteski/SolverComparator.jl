
# benchmark solvers on a set of problems
function compare_solvers(solvers,probs;title:: String = " ", kwargs...)
  bmark_args = Dict{Symbol, Any}(:skipif => model -> model.meta.ncon > 0, :max_f => 20000)#,:atol=>1e-10,:rtol=>1e-8)
  profile_args = Dict{Symbol, Any}(:title => title)
  stats, profiles = bmark_and_profile(solvers,
                                      (MathProgNLPModel(eval(p)(n), 
                                                        name=string(p)#, 
                                                        #features = [:Grad]
                                                        ) 
                                       for p in probs),
                                      bmark_args=bmark_args, profile_args=profile_args)
    #, :Jac, :Hess, :HessVec, :ExprGraph]),

  return stats, profiles
end


# Example 1c: benchmark solvers on a set of CUTEst problems... currently broken
function compare_solvers_CUTEst(solvers,probs;title:: String = " ", kwargs...)
  bmark_args = Dict{Symbol, Any}(:skipif => model -> (model.meta.ncon > 0) 
                                                  || (model.meta.nvar < n_min)
                                                  || (model.meta.nvar > n_max), 
                                 :max_f => 20000)#,:atol=>1e-10,:rtol=>1e-8)
  profile_args = Dict{Symbol, Any}(:title => title)
  stats, profiles = bmark_and_profile(solvers,
                                      (CUTEstModel(p)  for p in probs),
                                      bmark_args=bmark_args, profile_args=profile_args)
    # Other available features :Jac, :Hess, :HessVec, :ExprGraph

  return stats, profiles
end

# Example 1d: benchmark solvers on a set of AMPL problems... fails for Ipopt
function compare_solvers_Ampl(solvers,probs;title:: String = " ", kwargs...)
  bmark_args = Dict{Symbol, Any}(:skipif => model -> (model.meta.ncon > 0) 
                                                  || (model.meta.nvar < n_min)
                                                  || (model.meta.nvar > n_max), 
                                 :max_f => 20000)#,:atol=>1e-10,:rtol=>1e-8)
  profile_args = Dict{Symbol, Any}(:title => title)
  stats, profiles = bmark_and_profile(solvers,
                                      (AmplModel(string(ampl_prob_dir,p) ) 
                                       for p in probs),
                                      bmark_args=bmark_args, profile_args=profile_args)
    # Other available features :Jac, :Hess, :HessVec, :ExprGraph

  return stats, profiles
end
