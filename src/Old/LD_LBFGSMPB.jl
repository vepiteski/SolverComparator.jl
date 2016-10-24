function LD_LBFGSMPB(nlp :: AbstractNLPModel;
                     atol :: Float64 = 1e-8,
                     rtol :: Float64 = 1.0e-6,
                     itmax :: Int=5000, 
                     max_f :: Int=5000,
                     max_calls :: Int = 40000,
                     verbose :: Bool = true
                     )                
    
    NLoptModel = NLPtoMPB(nlp, 
                          NLoptSolver(algorithm=:LD_LBFGS,
                                      maxeval=max_calls ÷ 2,
                                      xtol_abs = 0,
                                      ftol_abs = 0,
                                      xtol_rel = 0,
                                      ftol_rel = 0)
                          );
    
    x0 = nlp.meta.x0
    g0 = grad(nlp,x0)
    ret = MathProgBase.optimize!(NLoptModel)
    
    minx = NLoptModel.x
    
    minf = NLoptModel.objval
    ming = grad(nlp,minx)
    gnorm2 = norm(ming)
    norm_g = norm(ming,Inf)
    
    iter = nlp.counters.neval_obj
    
    optimal = (norm_g < atol)|| (norm_g < (rtol * norm(g0))) || (isinf(minf) & (minf<0.0))
    
    if optimal status = :Optimal
    else status = ret
    end
    return (minx, minf, gnorm2, iter, optimal, ret == :MAXEVAL_REACHED, status)
end

