using Optimize
using SolverComparator
using OptimizationProblems
using NLPModels


# Other packages available

# L-BFGS-B  --  one solver; uses only :Grad
using Lbfgsb
include("../ExtSolvers/L-BFGS-B.jl")


# Optimize  --  two solvers,  trunk (:HesVec) and lbfgs (only :Grad)

n=100

probs = filter(name -> name != :OptimizationProblems 
                   && name != :sbrybnd
                   && name != :penalty2
                   && name != :penalty3, names(OptimizationProblems))


mpb_probs = (MathProgNLPModel(eval(p)(n),  name=string(p) )   for p in probs)
sprob = :morebv
tst_prob = MathProgNLPModel(eval(sprob)(n),  name=string(sprob) );



n_min = 0  # not used, OptimizationProblems may be adjusted
n_max = n

using LSDescentMethods
using LineSearch

solver = CG_PR

include("../compare_solvers.jl")

#using ARCTR
using HSL

solvers = [solver,solver,solver,solver,Newlbfgs,Newlbfgs]
labels = ["AW 0.001 0.02", "TR_Sec 0.001 0.02", "TR_Sec 0.1 0.9", "TR_SecA 0.001 0.02", "lbfgs TR_Sec","LbfgsB"] 
options = [Dict{Symbol,Any}(:τ₀=>0.001, :τ₁=>0.02, :verbose=>false, :verboseLS=>false, :atol=> 1.0e-6, :rtol => 0.0) 
           Dict{Symbol,Any}(:linesearch => TR_Sec_ls, :τ₀=>0.001, :τ₁=>0.02, :verbose=>false, :verboseLS=>false, :atol=> 1.0e-6, :rtol => 0.0) 
           Dict{Symbol,Any}(:linesearch => TR_Sec_ls,:τ₀=>0.1, :τ₁=> 0.9, :verbose=>false, :verboseLS=>false, :atol=> 1.0e-6, :rtol => 0.0) 
           Dict{Symbol,Any}(:linesearch => TR_SecA_ls,:τ₀=>0.001, :τ₁=> 0.02, :verbose=>false, :verboseLS=>false, :atol=> 1.0e-6, :rtol => 0.0) 
           Dict{Symbol,Any}(:linesearch => TR_Sec_ls, :verbose=>false, :verboseLS=>false, :atol=> 1.0e-6, :rtol => 0.0) 
           Dict{Symbol,Any}(:atol=> 1.0e-6, :rtol => 0.0)]

#s1, P1 = compare_solvers_with_options2(solvers, options, labels, mpb_probs, n_min, n_max)

#s1, P1 = compare_solvers_with_options2(solvers, options, labels, mpb_probs, n_min, n_max)
s1, P1 = compare_solvers_with_options2(solvers, options, labels, [tst_prob], n_min, n_max)
