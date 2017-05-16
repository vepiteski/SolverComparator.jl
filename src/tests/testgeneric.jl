using Optimize
using SolverComparator
using NLPModels



# select problem collection

n_min = 20
n_max = 200

# For the moment, impossible to mix collections
# Uncomment only one of mpb, ampl or cutest

# Math Prog Base collection
include("MPBProblems.jl")
test_probs = mpb_probs

# Ampl collection
#include("AmplProblems.jl")
#test_probs = ampl_probs

# CUTEst collection
#include("CUTEstProblems.jl")
#test_probs = cute_probs


# Select solvers

# official julia packages:  NLopt and Ipopt
include("../ExtSolvers/solvers.jl")

# Other packages available

# L-BFGS-B  --  one solver; uses only :Grad
#using Lbfgsb
#include("../ExtSolvers/L-BFGS-B.jl")

# Optimize  --  two solvers,  trunk (:HesVec) and lbfgs (only :Grad)
#using Optimize

using LSDescentMethods  

using ARCTR


stop_norm = ARCTR.stop_norm

solvers = [ARCMA57,   ARCMA57_abs ,  ST_TROp,   Newtrunk,   ARCqKOp,  Newton]
labels = []
for s in solvers push!(labels,convert(String,(last(rsplit(string(s),"."))))) end

options = [Dict{Symbol,Any}(:verbose=>false, :max_iter => 10000, :atol=> 1.0e-5, :rtol => 1.0e-10) 
           Dict{Symbol,Any}(:verbose=>false, :max_iter => 10000, :atol=> 1.0e-5, :rtol => 1.0e-10) 
           Dict{Symbol,Any}(:verbose=>false, :max_iter => 10000, :atol=> 1.0e-5, :rtol => 1.0e-10) 
           Dict{Symbol,Any}(:verbose=>false, :max_iter => 10000, :atol=> 1.0e-5, :rtol => 1.0e-10,
                            :monotone=>true)
           Dict{Symbol,Any}(:verbose=>false, :max_iter => 10000, :atol=> 1.0e-5, :rtol => 1.0e-10)
           Dict{Symbol,Any}(:verbose=>false, :max_iter => 10000, :atol=> 1.0e-5, :rtol => 1.0e-10,
                            :Nwtdirection => NwtdirectionCG, 
                            :hessian_rep => hessian_operator) 
           ]

#solvers = [ARCqKOp,  ARCqKOp]
#labels = []
#for s in solvers push!(labels,convert(String,(last(rsplit(string(s),"."))))) end
#labels[2] = string(labels[2] , " nr")

#options = [Dict{Symbol,Any}(:verbose=>false, :max_iter => 10000, :atol=> 1.0e-8, :rtol => 1.0e-10)
#           Dict{Symbol,Any}(:verbose=>false, :max_iter => 10000, :atol=> 1.0e-8, :rtol => 1.0e-10,
#                            :robust=>false) 
#           ]



include("../compare_solvers.jl")

s1, P1, t1, Pt1 = compare_solvers_with_options2(solvers, options, labels, test_probs, n_min, n_max, printskip = false)
