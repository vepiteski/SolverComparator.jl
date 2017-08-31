function Ipopt_LBFGSMPBS(nlp :: AbstractNLPModel;
                        stp :: TStopping = TStopping(),
                        verbose :: Bool = true
                        )                
    
    IpoptModel = NLPtoMPB(nlp, 
                          IpoptSolver(hessian_approximation="limited-memory",
                                      limited_memory_max_history=5,
                                      print_level = 0,
                                      max_iter = stp.max_iter,
                                      tol = stp.rtol,
                                      max_cpu_time = stp.max_time)
                          );
    
    x0 = nlp.meta.x0
    g0 = grad(nlp,x0)
    norm_g0 = norm(g0,Inf)
    ret = MathProgBase.optimize!(IpoptModel)
    
    minx = IpoptModel.inner.x
    
    minf = obj(nlp,minx)
    ming = grad(nlp,minx)
    gnorm2 = norm(ming)
    norm_g = norm(ming,Inf)
    
    iter = nlp.counters.neval_obj
    
    #ϵ = stp.atol + stp.rtol * norm_g0
    #optimal = (norm_g < ϵ) || (isinf(minf) & (minf<0.0))
    optimal, unbounded, tired, elapsed_time = stop(nlp,stp,iter,minx,minf,ming)
    
    if optimal status = :Optimal
    else status = ret
    end
    return (minx, minf, gnorm2, iter, optimal, ret == :MAXEVAL_REACHED, status)
end

