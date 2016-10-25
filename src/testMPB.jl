using OptimizationProblems
using JuMP
using NLPModels


# official julia packages:  NLopt and Ipopt
include("solvers.jl")


# Other packages available

# L-BFGS-B  --  one solver; uses only :Grad
using Lbfgsb
include("L-BFGS-B.jl")


# Optimize  --  two solvers,  trunk (:HesVec) and lbfgs (only :Grad)
using Optimize
mpb_probs = filter(name -> name != :OptimizationProblems && name != :sbrybnd, names(OptimizationProblems))

# ARCTR  --  24 solvers (use at least :HessVec, some :Hess)
using ARCTR

include("compare_solvers.jl")


solvers1 = [LD_LBFGS, Ipopt_LBFGSMPB, LbfgsB, lbfgs]
n=2500
s1, P1 = compare_solvers(solvers1, mpb_probs, title = "First order: #f + #g ")

solvers2 = [ARCMA97_abs, ARCSpectral_abs, IpoptMPB]
n=250   #  500 too large for ARCLDLt
s2, P2 = compare_solvers(solvers2, mpb_probs, title = "Second order but only #f + #g ")

solvers3 = [LD_TNEWTON, ARCqKOp, ST_TROp, TRKOp]
n=2500
s3, P3 = compare_solvers(solvers3, mpb_probs, title = "First order: #f + #g ")
