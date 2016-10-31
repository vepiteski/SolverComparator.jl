@eval begin
    function $fname(nlp :: AbstractNLPModel;
                    atol :: Float64 = 1e-8,
                    rtol :: Float64 = 1.0e-6,
                    itmax :: Int=5000, 
                    max_f :: Int=5000,
                    max_calls :: Int = 40000,
                    verbose :: Bool = true
                    )                
        NLoptModel = NLPtoMPB(nlp, 
                       NLoptSolver(algorithm=Symbol($fname),
                                   maxeval=max_calls ÷ 2,
                                   vector_storage = 5,
                                   xtol_abs = 0,
                                   ftol_abs = 0,
                                   xtol_rel = 0,
                                   ftol_rel = 0)
                       );

        x0 = nlp.meta.x0
        g0 = grad(nlp,x0)
        norm_g0 = norm(g0,Inf)
        ϵ = atol + rtol * norm_g0
        ret = MathProgBase.optimize!(NLoptModel)
  
        minx = NLoptModel.x

        minf = obj(nlp,minx)
        ming = grad(nlp,minx)
        gnorm2 = norm(ming)
        norm_g = norm(ming,Inf)

        iter = nlp.counters.neval_obj
        
        #optimal = ret in [:SUCCESS, :FTOL_REACHED, :XTOL_REACHED]
        optimal = (norm_g < ϵ) || (isinf(minf) & (minf<0.0))
        
        if optimal status = :Optimal
        else status = ret
        end
        return (minx, minf, gnorm2, iter, optimal, ret == :MAXEVAL_REACHED, status)
    end
end
