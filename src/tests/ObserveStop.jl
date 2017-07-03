using OptimizationProblems
using NLPModels


# Other packages available

# L-BFGS-B  --  one solver; uses only :Grad
#using Lbfgsb
#include("../ExtSolvers/L-BFGS-B.jl")


# Optimize  --  two solvers,  trunk (:HesVec) and lbfgs (only :Grad)

n=100

#probs = filter(name -> name != :OptimizationProblems 
#                   && name != :sbrybnd
#                   && name != :penalty2
#                   && name != :penalty3, names(OptimizationProblems))


#mpb_probs = (MathProgNLPModel(eval(p)(n),  name=string(p) )   for p in probs)
#sprob = :penalty2
#tst_prob = MathProgNLPModel(eval(sprob)(n),  name=string(sprob) );

# CUTEst collection
#include("CUTEstProblems.jl")

using CUTEst

prob = CUTEstModel("SCURLY10")

using ARCTR

#using LSDescentMethods
#using LineSearch
#solver = Newlbfgs
#solver = steepest
#solver = NewtonLDLt
#solver = Newton
#solver = CG_FR
#solver = CG_HZ
#solver = CG_HZ
#solver = CG_HS

using Stopping

stop_norm = ARCTR.stop_norm
atol=1.0e-6
rtol=1.0e-10

stop = TStopping(atol = atol, rtol = rtol, max_iter = 100000, max_eval = 100000, max_time = 600.0)

(x, f, ∇fNorm, iter, optimal, tired, status)=ARCqKOpS(prob, verbose=true, s=stop)
#(x, f, ∇fNorm, iter, optimal, tired, status)=ST_TROpS(prob, verbose=true, s=stop)
