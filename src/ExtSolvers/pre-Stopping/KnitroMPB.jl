function KnitroMPB(nlp :: AbstractNLPModel;
                        atol :: Float64 = 1e-8,
                        rtol :: Float64 = 1.0e-6,
                        itmax :: Int=5000, 
                        max_f :: Int=5000,
                        max_calls :: Int = 40000,
                        verbose :: Bool = true
                        )                
    
    KnitroModel = NLPtoMPB(nlp, 
                           KnitroSolver(KTR_PARAM_ALG=2,           # CG
                                        KTR_PARAM_PRESOLVE=0,
                                        KTR_PARAM_SCALE=0,
                                        KTR_PARAM_HESSOPT=5,       # matvecs only
                                        # KTR_PARAM_HESSOPT=6,     # lbfgs
                                        # KTR_PARAM_LMSIZE=10,     # number of lbfgs pairs
                                        KTR_PARAM_OPTTOL=rtol,     # relative tolerance
                                        KTR_PARAM_OPTTOLABS=atol,  # absolute tolerance
                                        KTR_PARAM_MAXIT=itmax,
                                        KTR_PARAM_OUTLEV=0,        # no output
                                        )
                          );

    x0 = nlp.meta.x0
    g0 = grad(nlp,x0)
    ret = MathProgBase.optimize!(KnitroModel)
    
    minx = KnitroModel.inner.x
    
    minf = obj(nlp,minx)
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

