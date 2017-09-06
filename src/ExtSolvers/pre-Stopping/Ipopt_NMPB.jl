function Ipopt_NMPB(nlp :: AbstractNLPModel;
                        atol :: Float64 = 1e-8,
                        rtol :: Float64 = 1.0e-6,
                        max_iter :: Int=5000, 
                        max_eval :: Int=5000,
                        max_calls :: Int = 40000,
                        verbose :: Bool = true
                        )                
    
    IpoptModel = NLPtoMPB(nlp, 
                          IpoptSolver(print_level = 0,
                                      max_iter = max_iter,
                                      tol = rtol)
                          );
    
    x0 = nlp.meta.x0
    g0 = grad(nlp,x0)
    norm_g0 = norm(g0,Inf)
    ϵ = atol + rtol * norm_g0
    ret = MathProgBase.optimize!(IpoptModel)
    
    minx = IpoptModel.inner.x
    
    minf = obj(nlp,minx)
    ming = grad(nlp,minx)
    gnorm2 = norm(ming)
    norm_g = norm(ming,Inf)
    
    iter = nlp.counters.neval_obj
    
    optimal = (norm_g < ϵ) || (isinf(minf) & (minf<0.0))
    
    if optimal status = :Optimal
    else status = ret
    end
    return (minx, minf, gnorm2, iter, optimal, ret == :MAXEVAL_REACHED, status)
end

