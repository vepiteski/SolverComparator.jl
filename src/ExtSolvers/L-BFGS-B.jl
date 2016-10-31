export LbfgsB

function LbfgsB(nlp :: AbstractNLPModel;
                atol :: Float64=1.0e-8, rtol :: Float64=1.0e-6,
                max_f :: Int=0,
                max_fg :: Int=0,
                MaxIters :: Int = 50000,
                verbose :: Bool=false,
                m :: Int=5)
    n = nlp.meta.nvar
    x₀ = copy(nlp.meta.x0)

    g = Array(Float64,n)
    g₀ = Array(Float64,n)
    g = grad(nlp,x₀)
    grad!(nlp,x₀,g₀)

    function _ogFunc!(x, g::Array{Float64})
        grad!(nlp, x, g);
        return obj(nlp,x);
    end

    max_f == 0 && (max_f = max(min(100, 2 * n), 500))
    max_fg == 0 && (max_fg = 2 * max_f)
    
    tolI = atol + rtol * norm(g₀,Inf) 
    verbose && println("LbfgsB: atol = ",atol," rtol = ",rtol," tolI = ",tolI, " norm(g₀) = ",norm(g₀))

    verblevel = verbose ? 1 : -1
    
    f, x, iterB, callB, status  = lbfgsb(_ogFunc!,
                                         x₀, 
                                         m=m,
                                         maxiter = min(MaxIters,max_fg),
                                         iprint = verblevel,
                                         factr = 0.0,
                                         pgtol = tolI)

    tired = ! ((iterB < MaxIters) | (callB < max_fg))

    grad!(nlp,x,g)
    gNorm = norm(g,Inf)

    optimal = gNorm <= tolI

    calls = [nlp.counters.neval_obj, nlp.counters.neval_grad, nlp.counters.neval_hess, nlp.counters.neval_hprod]  
    if tired status = :UserLimit 
    elseif optimal  status =  :Optimal
    else status =  :SubOptimal
    end

    return (x, f, gNorm, iterB, optimal, tired, status)
end
