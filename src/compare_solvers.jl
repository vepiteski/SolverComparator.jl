
# benchmark solvers on a set of problems
function compare_solvers(solvers,probs;title:: String = " ", kwargs...)
  bmark_args = Dict{Symbol, Any}(:skipif => model -> model.meta.ncon > 0, :max_f => 20000)#,:atol=>1e-10,:rtol=>1e-8)
  profile_args = Dict{Symbol, Any}(:title => title)
  stats, profiles = bmark_and_profile(solvers,
                                      #(MathProgNLPModel(eval(p)(n), name=string(p)) for p in mpb_probs),

                                      (MathProgNLPModel(eval(p)(n), 
                                                        name=string(p)#, 
                                                        #features = [:Grad]
                                                        ) 
                                       for p in probs),
                                      bmark_args=bmark_args, profile_args=profile_args)
    #, :Jac, :Hess, :HessVec, :ExprGraph]),

  return stats, profiles
end
