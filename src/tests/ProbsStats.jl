using NLPModels

TestCUTEst = false

include("CUTEstProblems.jl")
test_probs = cute_probs
TestCUTEst = true

# Math Prog Base collection
#n_max = 100
#include("MPBProblems.jl")
#test_probs = mpb_probs

# Ampl collection
#include("AmplProblems.jl")
#test_probs = ampl_probs

for problem in test_probs
    x0 = problem.meta.x0
    #H = hess(problem,x0)
    f = obj(problem,x0)
    normg = norm(grad(problem,x0))
    #nnzH = nnz(H)
    nnzMeta = problem.meta.nnzh

    nvar = problem.meta.nvar
    
    @printf("\n %-15s  %8d normg: %10.3e  nnzH:  %8d  Hdensity  %5f ", problem.meta.name, nvar, normg, nnzMeta, float(2*nnzMeta)/float(nvar*(nvar+1)))
    if !unconstrained(problem) @printf(" constrained ") end
    finalize(problem)
end

TestCUTEst && include("CleanCUTE.jl")
