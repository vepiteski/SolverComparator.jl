using Optimize
using SolverComparator
using OptimizationProblems
using NLPModels


# official julia packages:  NLopt and Ipopt
include("../ExtSolvers/solvers.jl")


# Other packages available

# L-BFGS-B  --  one solver; uses only :Grad
#using Lbfgsb
#include("../ExtSolvers/L-BFGS-B.jl")


# Optimize  --  two solvers,  trunk (:HesVec) and lbfgs (only :Grad)


n=10
probs = filter(name -> name != :OptimizationProblems 
                   && name != :sbrybnd
                   && name != :penalty2
                   && name != :penalty3, names(OptimizationProblems))

# ARCTR  --  24 solvers (use at least :HessVec, some :Hess)
using ARCTR

mpb_probs = (MathProgNLPModel(eval(p)(n),  name=string(p) )   for p in probs)


solvers1 = [lbfgs, LD_LBFGS, Ipopt_LBFGSMPB] #, LbfgsB]

n_min = 0  # not used, OptimizationProblems may be adjusted
n_max = n

include("../compare_solvers.jl")

s1, P1 = compare_solvers(solvers1, mpb_probs, n_min, n_max, title = "First order: #f + #g ", printskip = true)

solvers2 = [ARCSpectral_abs, ARCMA97_abs, Ipopt_NMPB]
s2, P2 = compare_solvers(solvers2, mpb_probs, n_min, n_max, title = "Second order but only #f + #g ")

solvers3 = [LD_TNEWTON, ARCqKOp, ST_TROp, TRKOp, trunk]
s3, P3 = compare_solvers(solvers3, mpb_probs, n_min, n_max, title = "First order: #f + #g ")
