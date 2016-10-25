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

ampl_prob_dir = "/home/local/USHERBROOKE/dusj1701/Documents/Recherche/TR-ARC/UnifiedImplementation/Julia/AMPLUnconstrained/"
ampl_probs = [Symbol(split(p, ".")[1]) for p in filter(x -> contains(x, ".nl"), readdir(ampl_prob_dir))]

n_min = 1
n_max = 1000



solvers1 = [LD_LBFGS, LbfgsB, lbfgs]
s1, P1 = compare_solvers_Ampl(solvers1, ampl_probs, title = "First order: #f + #g ")

solvers2 = [ARCMA97_abs, ARCLDLt_abs]
n_max = 100
s2, P2 = compare_solvers_Ampl(solvers2, ampl_probs, title = "Second order but only #f + #g ")

solvers3 = [trunk, ARCqKOp, ST_TROp, TRKOp]
n_max = 1000
s3, P3 = compare_solvers_Ampl(solvers3, ampl_probs, title = "First order: #f + #g ")
