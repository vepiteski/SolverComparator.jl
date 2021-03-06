using Optimize
using SolverComparator
using OptimizationProblems
using NLPModels
using CUTEst


# Other packages available

# L-BFGS-B  --  one solver; uses only :Grad
using Lbfgsb
include("../ExtSolvers/L-BFGS-B.jl")


# Optimize  --  two solvers,  trunk (:HesVec) and lbfgs (only :Grad)
n=5000
probs = open(readlines,"CUTEstUnc.list")
Nprobs = length(probs)

cute_probs = (CUTEstModel(p)  for p in probs)



n_min = 500 
n_max = n

using LSDescentMethods
using LineSearch


include("../compare_solvers.jl")

using ARCTR


#solvers1 = [ARCSpectral,TRSpectral, ARCSpectral_abs, TRSpectral_abs, NewtonSpectral]
#labels = ["ARCSpectral", "TRSpectral", "ARCSpectral_abs", "TRSpectral_abs", "NewtonSpectral"]

using HSL
#solvers1 = [NewtonSpectral, ARCSpectral,TRSpectral, ARCSpectral_abs, TRSpectral_abs]
#labels = ["NewtonSpectral", "ARCSpectral", "TRSpectral", "ARCSpectral_abs", "TRSpectral_abs"]

solvers1 = [ ARCqKOp,   NewtonMA57,   ARCMA57,   TRMA57,   ARCMA57_abs,   TRMA57_abs]
labels =   ["ARCqKOp", "NewtonMA57", "ARCMA57", "TRMA57", "ARCMA57_abs", "TRMA57_abs"]

solvers1 = [ ARCqKOp,   NewtonMA57,   ARCMA57,   ARCMA57_abs]
labels =   ["ARCqKOp", "NewtonMA57", "ARCMA57", "ARCMA57_abs"]

include("../compare_solvers.jl")
options = [Dict{Symbol,Any}(:verbose=>false, :atol=> 1.0e-5, :rtol => 1.0e-10)
           Dict{Symbol,Any}(:verbose=>false, :verboseLS=>false, :atol=> 1.0e-5, :rtol => 1.0e-10)
           Dict{Symbol,Any}(:verbose=>false, :atol=> 1.0e-5, :rtol => 1.0e-10) 
           Dict{Symbol,Any}(:verbose=>false, :atol=> 1.0e-5, :rtol => 1.0e-10) 
           Dict{Symbol,Any}(:verbose=>false, :atol=> 1.0e-5, :rtol => 1.0e-10) 
           Dict{Symbol,Any}(:verbose=>false, :atol=> 1.0e-5, :rtol => 1.0e-10)
           ]
#sprob = "STRATEC"
#tst_prob = CUTEstModel(sprob)
#solver = ARCSpectral
#(x, f, ∇fNorm, iter, optimal, tired, status)=solver(tst_prob)#,verboseLS=false)

s1, P1, t1, Pt1 = compare_solvers_with_options2(solvers1, options, labels, cute_probs, n_min, n_max, title = "First order: #f + #g ", printskip = false)

include("CleanCUTE.jl")
