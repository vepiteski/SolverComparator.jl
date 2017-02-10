using Optimize
using SolverComparator
using OptimizationProblems
using NLPModels

n=1000
probs = filter(name -> name != :OptimizationProblems 
                   && name != :sbrybnd
                   && name != :penalty2
                   && name != :penalty3, names(OptimizationProblems))

# ARCTR  --  2? solvers (use at least :HessVec, some :Hess)
using ARCTR

mpb_probs = (MathProgNLPModel(eval(p)(n),  name=string(p) )   for p in probs)

include("../ExtSolvers/solvers.jl")

solvers1 = [ARCMA57_abs, ARCMA97_abs, ARCSpectral_abs, Ipopt_NMPB] #, LbfgsB]
#solvers1 = [ARCLDLt, ARCLDLt_abs, ARCMA57, ARCMA57_abs, ARCMA97, ARCMA97_abs] #, LbfgsB]
#solvers1 = [ARCMA57, ARCMA57_abs, TRMA57, TRMA57_abs, Ipopt_NMPB] #, LbfgsB]



n_min = 0  # not used, OptimizationProblems may be adjusted
n_max = n

include("../compare_solvers.jl")

s1, P1 = compare_solvers(solvers1, mpb_probs, n_min, n_max, title = "First order: #f + #g ", printskip = true)
