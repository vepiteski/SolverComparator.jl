using OptimizationProblems
using NLPModels


# Other packages available

# L-BFGS-B  --  one solver; uses only :Grad
#using Lbfgsb
#include("../ExtSolvers/L-BFGS-B.jl")


# Optimize  --  two solvers,  trunk (:HesVec) and lbfgs (only :Grad)

n=100

probs = filter(name -> name != :OptimizationProblems 
                   && name != :sbrybnd
                   && name != :penalty2
                   && name != :penalty3, names(OptimizationProblems))


mpb_probs = (MathProgNLPModel(eval(p)(n),  name=string(p) )   for p in probs)
sprob = :curly
tst_prob = MathProgNLPModel(eval(sprob)(n),  name=string(sprob) );



using LSDescentMethods
using LineSearch
#solver = Newlbfgs
#solver = steepest
#solver = NewtonLDLt
solver = Newton
#solver = CG_FR
#solver = CG_HZ
#solver = CG_HZ
#solver = CG_HS
(x, f, ∇fNorm, iter, optimal, tired, status)=solver(tst_prob,verbose=true, verboseCG=true, atol=1e-6, rtol=0.0, Nwtdirection = NwtdirectionCG, hessian_rep = hessian_dense)
