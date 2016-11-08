#using OptimizationProblems
#using JuMP
using NLPModels
using AmplNLReader

using JLD

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

using SolverComparator

ampl_prob_dir = "../ampl/"
probs = [Symbol(split(p, ".")[1]) for p in filter(x -> contains(x, ".nl") 
                                                       && x != "hs068.nl"
                                                       && x != "hs069.nl"
                                                       && x != "drcavty1.nl"
                                                       && x != "drcavty2.nl"
                                                       && x != "drcavty3.nl",
                                                       readdir(ampl_prob_dir))]

ampl_probs = (AmplModel(string(ampl_prob_dir,p) )  for p in probs)

n_min = 1
n_max = 100

solvers1 = [LD_LBFGS, LbfgsB, lbfgs, Ipopt_LBFGSMPB] # LD_LBFGS, 
s1, P1 = compare_solvers(solvers1, ampl_probs, n_min, n_max, title = "First order: #f + #g ")
#save("s1P1.jld","s1",s1)

solvers2 = [ARCMA97_abs, ARCSpectral_abs, IpoptMPB]
#n_max = 500
#s2, P2 = compare_solvers(solvers2, ampl_prob_dir, ampl_probs, n_min, n_max, title = "Second order but only #f + #g ")
#save("s2P2.jld","s2",s2)

solvers3 = [LD_TNEWTON, ARCqKsparse, ST_TRsparse, TRKsparse] # trunk, # Hprod bugs, needs matrix
n_max = 10000
s3, P3 = compare_solvers(solvers3, ampl_prob_dir, ampl_probs, n_min, n_max, title = "First order: #f + #g ")
save("s3P3.jld","s3",s3)
