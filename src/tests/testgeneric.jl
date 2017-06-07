using Optimize
using SolverComparator
using NLPModels



# select problem collection

n_min = 20
n_max = 10000

# For the moment, impossible to mix collections
# Uncomment only one of mpb, ampl or cutest

# Math Prog Base collection
#include("MPBProblems.jl")
#test_probs = mpb_probs

# Ampl collection
#include("AmplProblems.jl")
#test_probs = ampl_probs

# CUTEst collection
include("CUTEstProblems.jl")
test_probs = cute_probs


# Select solvers

# official julia packages:  NLopt and Ipopt
include("../ExtSolvers/solvers.jl")

# Other packages available

# L-BFGS-B  --  one solver; uses only :Grad
using Lbfgsb
include("../ExtSolvers/L-BFGS-B.jl")

# Optimize  --  two solvers,  trunk (:HesVec) and lbfgs (only :Grad)
#using Optimize

using LSDescentMethods  

using ARCTR


stop_norm = ARCTR.stop_norm
atol=1.0e-6
rtol=1.0e-10

#solvers = [ARCMA57,   ARCMA57_abs ,  ST_TRsparse,  ARCqKsparse,  Newton, Ipopt_LBFGSMPB]
#solvers = [Ipopt_NMPB,   TRKsparse ,  ST_TRsparse,  ARCqKsparse,  Newton]
solvers = [Ipopt_NMPB,   ARCMA57_abs, ARCMA57, ARCqKOp, ARCqKsparse, Newton]
labels = []
for s in solvers push!(labels,convert(String,(last(rsplit(string(s),"."))))) end

options = [Dict{Symbol,Any}(:verbose=>false, :max_iter => 10000, :atol=> atol, :rtol => rtol) 
           Dict{Symbol,Any}(:verbose=>false, :max_iter => 10000, :atol=> atol, :rtol => rtol) 
           Dict{Symbol,Any}(:verbose=>false, :max_iter => 10000, :atol=> atol, :rtol => rtol) 
           Dict{Symbol,Any}(:verbose=>false, :max_iter => 10000, :atol=> atol, :rtol => rtol) 
           Dict{Symbol,Any}(:verbose=>false, :max_iter => 10000, :atol=> atol, :rtol => rtol)
           Dict{Symbol,Any}(:verbose=>false, :max_iter => 10000, :atol=> atol, :rtol => rtol,
                            :Nwtdirection => NwtdirectionMA57, 
                            :hessian_rep => hessian_sparse) 
           ]

#solvers = [TRMA57_abs, TRMA57_abs, TRMA57, TRMA57]
#solvers = [TRMA57_abs, ARCMA57_abs, TRMA57, ARCMA57]
#labels = []
#for s in solvers push!(labels,convert(String,(last(rsplit(string(s),"."))))) end
#labels[1] = string(labels[1]," robust")
#labels[3] = string(labels[3]," robust")


#options = [Dict{Symbol,Any}(:verbose=>false, :max_iter => 100000, :atol=> atol, :rtol => rtol)
           #Dict{Symbol,Any}(:verbose=>false, :max_iter => 100000, :atol=> atol, :rtol => rtol, :robust => false)
#           Dict{Symbol,Any}(:verbose=>false, :max_iter => 100000, :atol=> atol, :rtol => rtol)
#           Dict{Symbol,Any}(:verbose=>false, :max_iter => 100000, :atol=> atol, :rtol => rtol)
#           Dict{Symbol,Any}(:verbose=>false, :max_iter => 100000, :atol=> atol, :rtol => rtol)
#           Dict{Symbol,Any}(:verbose=>false, :max_iter => 100000, :atol=> atol, :rtol => rtol, :robust => false)
#Dict{Symbol,Any}(:verbose=>false, :max_iter => 100000, :atol=> atol, :rtol => rtol,
           #                 :monotone=>true)
#           ]



include("../compare_solvers.jl")

s1, P1, t1, Pt1 = compare_solvers_with_options2(solvers, options, labels, test_probs, n_min, n_max, printskip = false)


include("CleanCUTE.jl")
