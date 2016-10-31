#using OptimizationProblems
#using JuMP
using NLPModels
using AmplNLReader

# official julia packages:  NLopt and Ipopt
include("solvers.jl")


# Other packages available

# L-BFGS-B  --  one solver; uses only :Grad
using Lbfgsb
include("L-BFGS-B.jl")


# Optimize  --  two solvers,  trunk (:HesVec) and lbfgs (only :Grad)
using Optimize



# ARCTR  --  24 solvers (use at least :HessVec, some :Hess)
using ARCTR

include("compare_solvers.jl")


lprobs = open(readlines,"Unc.list")
Nprobs = length(lprobs)

n_min = 1
n_max = 100



solvers1 = [LD_LBFGS, LbfgsB, lbfgs]
s1, P1 = compare_solvers_CUTEst(solvers1, lprobs, title = "First order: #f + #g ")

solvers2 = [ARCMA97_abs, ARCSpectral_abs]
n_max = 100
s2, P2 = compare_solvers_CUTEst(solvers2, lprobs, title = "Second order but only #f + #g ")

solvers3 = [trunk, ARCqKOp, ST_TROp, TRKOp]
n_max = 1000
s3, P3 = compare_solvers_CUTEst(solvers3, lprobs, title = "First order: #f + #g ")
