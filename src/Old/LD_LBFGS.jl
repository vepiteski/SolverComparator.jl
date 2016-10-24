
"Exception type raised in case of error inside LD_LBFGS."
type LD_LBFGSException <: Exception
  msg  :: String
end


function LD_LBFGS(nlp :: AbstractNLPModel;
                  kwargs... )  

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

    opt = Opt(:LD_TNEWTON_PRECOND_RESTART, n)
    
    min_objective!(opt, (x,g) -> myfunc!(x,g,nlp))
    ret :: Any
    #try 
          (minf,minx,ret) = optimize(opt, x0)
    #catch e
    #    throw(LD_LBFGSException("problem in LD_LBFGS"))
    #end


    gnorm2 = norm(grad(nlp,minx))
    iter = nlp.counters.neval_obj
    
    optimal = ret in [:SUCCESS, :FTOL_REACHED, :XTOL_REACHED]

    if optimal status = :Optimal
    else status = :not_optimal
    end
    return (minx, minf, gnorm2, iter, optimal, ret == :MAXEVAL_REACHED, status)
end
