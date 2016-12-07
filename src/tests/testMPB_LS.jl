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
tst_prob = MathProgNLPModel(eval(:arwhead)(n),  name=string(:arwhead) );



n_min = 0  # not used, OptimizationProblems may be adjusted
n_max = n

using LSDescentMethods
using LineSearch
solver = Newlbfgs
#solver(tst_prob)

include("../compare_solvers.jl")

options = [Dict{Symbol,Any}(:linesearch => TR_Sec_ls) 
           Dict{Symbol,Any}(:linesearch => TR_SecA_ls) 
           Dict{Symbol,Any}() ]

s1, P1 = compare_solver_options(solver, options, mpb_probs, n_min, n_max)

