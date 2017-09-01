@eval begin
    function $fname(nlp :: AbstractNLPModel;
                    stp :: TStopping = TStopping(),
                    verbose :: Bool = true
                    )                
        NLoptModel = NLPtoMPB(nlp, 
                       NLoptSolver(algorithm=Symbol($fname),
                                   maxeval=stp.max_eval ÷ 2,
                                   maxtime=stp.max_time,
                                   vector_storage = 5,
                                   xtol_abs = 0,
                                   ftol_abs = 0,
                                   xtol_rel = 0,
                                   ftol_rel = 0)
                       );

        x0 = nlp.meta.x0
        g0 = grad(nlp,x0)
        norm_g0 = norm(g0,Inf)
        ret = MathProgBase.optimize!(NLoptModel)
  
        minx = NLoptModel.x

        minf = obj(nlp,minx)
        ming = grad(nlp,minx)
        gnorm2 = norm(ming)
        norm_g = norm(ming,Inf)

        iter = nlp.counters.neval_obj
        
        #optimal = ret in [:SUCCESS, :FTOL_REACHED, :XTOL_REACHED]
        #ϵ = stp.atol + stp.rtol * norm_g0
        #optimal = (norm_g < ϵ) || (isinf(minf) & (minf<0.0))
        optimal, unbounded, tired, elapsed_time = stop(nlp,stp,iter,minx,minf,ming)
        
        if optimal status = :Optimal
        else status = ret
        end
        return (minx, minf, gnorm2, iter, optimal, ret == :MAXEVAL_REACHED, status)
    end

    push!(NLoptSolvers,$fname)
end
