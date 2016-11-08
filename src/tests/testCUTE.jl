#using OptimizationProblems
#using JuMP
using NLPModels
using Optimize
using SolverComparator
using CUTEst

# official julia packages:  NLopt and Ipopt
include("../ExtSolvers/solvers.jl")


# Other packages available

# L-BFGS-B  --  one solver; uses only :Grad
using Lbfgsb
include("../ExtSolvers/L-BFGS-B.jl")


# Optimize  --  two solvers,  trunk (:HesVec) and lbfgs (only :Grad)
#using Optimize



# ARCTR  --  24 solvers (use at least :HessVec, some :Hess)
using ARCTR

#include("compare_solvers.jl")


probs = open(readlines,"CUTEstUnc.list")
Nprobs = length(probs)

lprobs = (CUTEstModel(p)  for p in probs)

n_min = 1
n_max = 10



solvers1 = [LD_LBFGS, LbfgsB, lbfgs]
s1, P1 = compare_solvers(solvers1, lprobs, n_min, n_max, title = "First order: #f + #g ")

solvers2 = [ARCMA97_abs, ARCSpectral_abs]
n_max = 100
s2, P2 = compare_solvers(solvers2, lprobs, n_min, n_max, title = "Second order but only #f + #g ")

solvers3 = [trunk, ARCqKOp, ST_TROp, TRKOp]
n_max = 1000
s3, P3 = compare_solvers(solvers3, lprobs, n_min, n_max, title = "First order: #f + #g ")

lib_so_files = [f for f in filter(x -> contains(x,".so"),readdir())]
for str in lib_so_files run(`rm $str `) end
run(`rm AUTOMAT.d`)
run(`rm OUTSDIF.d`)
