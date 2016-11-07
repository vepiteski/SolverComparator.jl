using OptimizationProblems
using JuMP
using NLPModels


# official julia packages:  NLopt and Ipopt
include("../ExtSolvers/solvers.jl")


# Other packages available

# L-BFGS-B  --  one solver; uses only :Grad
#using Lbfgsb
#include("../ExtSolvers/L-BFGS-B.jl")


# Optimize  --  two solvers,  trunk (:HesVec) and lbfgs (only :Grad)
using Optimize
mpb_probs = filter(name -> name != :OptimizationProblems 
                   && name != :sbrybnd
                   && name != :penalty2
                   && name != :penalty3, names(OptimizationProblems))

# ARCTR  --  24 solvers (use at least :HessVec, some :Hess)
using ARCTR

using SolverComparator

solvers1 = [lbfgs, LD_LBFGS, Ipopt_LBFGSMPB] #, LbfgsB]
n=10
s1, P1 = compare_solvers(solvers1, mpb_probs, n, title = "First order: #f + #g ", printskip = true)

solvers2 = [ARCSpectral_abs, ARCMA97_abs, IpoptMPB]
#n=2000   #  500 too large for ARCLDLt
s2, P2 = compare_solvers(solvers2, mpb_probs, n, title = "Second order but only #f + #g ")

solvers3 = [LD_TNEWTON, ARCqKOp, ST_TROp, TRKOp, trunk]
#n=10000
s3, P3 = compare_solvers(solvers3, mpb_probs, n, title = "First order: #f + #g ")
