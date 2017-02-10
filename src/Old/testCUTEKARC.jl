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
using Optimize


# ARCTR  --  24 solvers (use at least :HessVec, some :Hess)
using ARCTR


probs = open(readlines,"CUTEstUnc.list")
Nprobs = length(probs)

lprobs = (CUTEstModel(p)  for p in probs)

n_min = 100
n_max = 100000


solvers1 = [ARCqKOp,TRKOp, ST_TROp, LbfgsB, trunk]

include("../compare_solvers.jl")

s1, P1 = compare_solvers(solvers1, lprobs, n_min, n_max, title = "First order: #f + #g ", printskip = true)

# Clean up the directory after the tests
lib_so_files = filter(x -> contains(x,".so"),readdir())
for str in lib_so_files run(`rm $str `) end
run(`rm AUTOMAT.d`)
run(`rm OUTSDIF.d`)
