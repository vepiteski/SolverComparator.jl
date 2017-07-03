function Ipopt_LBFGSMPBS(nlp :: AbstractNLPModel;
                        s :: TStopping = TStopping(),
                        verbose :: Bool = true
                        )                
    
    IpoptModel = NLPtoMPB(nlp, 
                          IpoptSolver(hessian_approximation="limited-memory",
                                      limited_memory_max_history=5,
                                      print_level = 0,
                                      max_iter = s.max_iter,
                                      tol = s.rtol,
                                      max_cpu_time = s.max_time)
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

