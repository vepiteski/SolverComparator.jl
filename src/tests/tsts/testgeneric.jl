using Optimize
#using BenchmarkProfiles
using SolverComparator
using NLPModels

using Plots
pyplot()

# select problem collection

n_min = 20
n_max = 50000

TestCUTEst = false

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
TestCUTEst = true


# Select solvers

# official julia packages:  NLopt and Ipopt
include("../../ExtSolvers/solvers.jl")

# Other packages available

# L-BFGS-B  --  one solver; uses only :Grad
using Lbfgsb
include("../../ExtSolvers/L-BFGS-B.jl")

using ARCTR
using LSDescentMethods


stop_norm = ARCTR.stop_norm
atol=1.0e-6
rtol=1.0e-10

#solvers = [TRMA57_absNew, TRMA57_abs, TRMA57Old, TRMA57New]
#solvers = [TRKOpS, ARCqKOpS, ST_TROpS,LbfgsB]#, LbfgsB]
solvers = [TRMA57_absS, ARCMA57_absS, TRMA57S, ARCMA57S, Ipopt_NMPBS, NewtonS]#, LbfgsB]
#solvers = [TRLDLt_absS, ARCLDLt_absS, ARCLDLtS, TRLDLtS]
#solvers = [TRLDLt_abs, TRLDLtNew, TRLDLt_absNew]
#solvers = [TRMA57_absNew, TRMA57_absNew]
labels = []
for s in solvers push!(labels,convert(String,(last(rsplit(string(s),"."))))) end

using Stopping

stop = TStopping(atol = atol, rtol = rtol, max_iter = 100000, max_eval = 100000, max_time = 600.0)

options = [Dict{Symbol,Any}(:verbose=>false, :s => stop)
           Dict{Symbol,Any}(:verbose=>false, :s => stop)
           Dict{Symbol,Any}(:verbose=>false, :s => stop)
           Dict{Symbol,Any}(:verbose=>false, :s => stop)
           Dict{Symbol,Any}(:verbose=>false, :s => stop)
           Dict{Symbol,Any}(:verbose=>false, :s => stop, :Nwtdirection=>NwtdirectionMA57,
                            :hessian_rep => hessian_sparse)
           ]


include("../../compare_solvers.jl")

s1, P1, t1, Pt1 = compare_solvers_with_options2(solvers, options, labels, test_probs, n_min, n_max, printskip = false)

TestCUTEst && include("CleanCUTE.jl")
