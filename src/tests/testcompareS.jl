using Optimize
using SolverComparator
using NLPModels
using Stopping


# select problem collection
n_min = 2
n_max = 12

# For the moment, impossible to mix collections
# Uncomment only one of mpb, ampl or cutest

# Math Prog Base collection
using OptimizationProblems
probs = [:arwhead :chainwoo :rosenbrock]
test_probs = (MathProgNLPModel(eval(p)(n_max),  name=string(p) )   for p in probs)

# Ampl collection
#include("AmplProblems.jl")
#test_probs = ampl_probs

# CUTEst collection
#include("CUTEstProblems.jl")
#test_probs = cute_probs


# Select solvers

# official julia packages:  NLopt and Ipopt
#include("../ExtSolvers/solvers.jl")

# Other packages available

# L-BFGS-B  --  one solver; uses only :Grad
#using Lbfgsb
#include("../ExtSolvers/L-BFGS-B.jl")

# Optimize  --  two solvers,  trunk (:HesVec) and lbfgs (only :Grad)
#using Optimize

#using LSDescentMethods  

using ARCTR

atol = 1.0e-5
rtol = 1.0e-10
stp = TStopping(atol = atol, rtol = rtol, max_iter = 10000, max_eval = 10000, max_time = 50.0)


#stop_norm = ARCTR.stop_norm
solvers = [ ST_TROpS,   NewtrunkS,   ARCqKOpS]
labels = []
for s in solvers push!(labels,convert(String,(last(rsplit(string(s),"."))))) end

options = [#Dict{Symbol,Any}(:verbose=>false, :max_iter => 10000, :atol=> atol, :rtol => rtol) 
           #Dict{Symbol,Any}(:verbose=>false, :max_iter => 10000, :atol=> atol, :rtol => rtol) 
           #Dict{Symbol,Any}(:verbose=>false, :max_iter => 10000, :atol=> atol, :rtol => rtol) 
           Dict{Symbol,Any}(:verbose=>false, :stp => stp)
           Dict{Symbol,Any}(:verbose=>false, :stp => stp)
           Dict{Symbol,Any}(:verbose=>false, :stp => stp)
           ]

include("../compare_solvers.jl")

s1, P1 = compare_solvers_with_options(solvers, options, labels, test_probs, n_min, n_max, printskip = false)

s2, P2, t2, Pt2 = compare_solvers_with_options2(solvers, options, labels, test_probs, n_min, n_max, printskip = false)

#s1b = Dict{Symbol, Array{Int,2}}()
#for s in solvers s1b[Symbol(convert(String,(last(rsplit(string(s),".")))))] = s2[Symbol(convert(String,(last(rsplit(string(s),".")))))][:, 1:3] end

#@test s1b == s1
