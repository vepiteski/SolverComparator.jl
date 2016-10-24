@eval begin
    function $fname(nlp :: AbstractNLPModel;
                    atol :: Float64 = 1e-8,
                    rtol :: Float64 = 1.0e-6,
                    itmax :: Int=5000, 
                    max_f :: Int=5000,
                    max_calls :: Int = 40000,
                    verbose :: Bool = true
                    )                
        
        function myfunc!(x::Vector, g::Vector, m::AbstractNLPModel)
            if length(g) > 0
                grad!(m, x, g)
            end
            
            obj(m, x)
        end
        
        x0 = nlp.meta.x0
        n = nlp.meta.nvar
        minx = copy(x0)
        minf = Inf
        g0 = grad(nlp,x0)
        
        opt = Opt(Symbol($fname), n)
        min_objective!(opt, (x,g) -> myfunc!(x,g,nlp))
        maxeval!(opt,max_calls ÷ 2)

        # Caution, tolerances not on gradient's norm but on 
        #xtol_abs!(opt,atol/100.0)
        #ftol_abs!(opt,atol/100000.0)
        #xtol_rel!(opt,rtol/100.0)
        #ftol_rel!(opt,rtol/100000.0)


        (minf,minx,ret) = optimize(opt, x0)
        
        ming = grad(nlp,minx)
        gnorm2 = norm(ming)
        norm_g = norm(ming,Inf)

        iter = nlp.counters.neval_obj
        
        #optimal = ret in [:SUCCESS, :FTOL_REACHED, :XTOL_REACHED]
        optimal = (norm_g < atol)|| (norm_g < (rtol * norm(g0))) || (isinf(minf) & (minf<0.0))
        
        if optimal status = :Optimal
        else status = ret
        end
        return (minx, minf, gnorm2, iter, optimal, ret == :MAXEVAL_REACHED, status)
    end
end
