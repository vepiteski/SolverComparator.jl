using Optimize
using SolverComparator
using OptimizationProblems
using NLPModels


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


mpb_probs = (MathProgNLPModel(eval(p)(n),  name=string(p) )   for p in probs)
tst_prob = MathProgNLPModel(eval(:woods)(n),  name=string(:woods) );



n_min = 0  # not used, OptimizationProblems may be adjusted
n_max = n

using LSDescentMethods
using LineSearch
#solver = Newlbfgs
#solver = steepest
#solver = Newton
#(x, f, ∇fNorm, iter, optimal, tired, status)=solver(tst_prob)

include("../compare_solvers.jl")

solvers = [steepest,Newlbfgs,Newton, CG_PR]

labels = ["steepestSimple0.2-0.6", "lbfgsSimple","Newton","CG"]

options = [Dict{Symbol,Any}(:τ₀=>0.2, :τ₁=>0.6) 
           Dict{Symbol,Any}() 
           Dict{Symbol,Any}() 
           Dict{Symbol,Any}(:linesearch=>TR_Sec_ls, :τ₀=>0.4, :τ₁=>0.6)  ] # The basic greedy line search

s1, P1 = compare_solvers_with_options(solvers, options, labels, mpb_probs, n_min, n_max)

#s1, P1 = compare_solver_options(solver, options, mpb_probs, n_min, n_max)
