using Optimize
#using BenchmarkProfiles
#using SolverComparator
using NLPModels

using Plots
pyplot()

# select problem collection

n_min = 20
n_max = 10000

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
#using LineSearch
using Stopping

# official julia packages:  NLopt and Ipopt
include("../ExtSolvers/solversS.jl")

# Other packages available

# L-BFGS-B  --  one solver; uses only :Grad
#using Lbfgsb
#include("../ExtSolvers/L-BFGS-B.jl")

using ARCTR
using LSDescentMethods


#stop_norm = ARCTR.stop_norm
atol=1.0e-5
rtol=1.0e-10

#solvers = [ARCMA57_absS]
#solvers = [TRMA57_absOld, TRMA57_abs, TRMA57_absS]
#solvers = [TRKOpS, ARCqKOpS, ST_TROpS,LbfgsB]#, LbfgsB]
solvers = [ST_TROpS, ARCqKOpS, NewtrunkS, NewtrunkS, Newton,LD_TNEWTON_PRECOND]#ARCMA57_absS, ARCMA57S]#, LbfgsB]
#solvers = [TRMA57_absS, ARCMA57_absS, TRMA57S, ARCMA57S, TRMA97_absS, ARCMA97_absS, TRMA97S, ARCMA97S, Ipopt_NMPBS]#, LbfgsB]
#solvers = [ARCMA57_absS, ARCMA97_absS, ARCSpectral_absS,ARCLDLt_absS]#, LbfgsB]
#solvers = [TRMA97_absS, ARCMA97_absS, TRMA97S, ARCMA97S, Ipopt_NMPBS]#, LbfgsB]
#solvers = [ST_TROpS, ARCqKOpS, LbfgsBS, Ipopt_LBFGSMPBS]
#solvers = [TRLDLt_absS, ARCLDLt_absS, ARCLDLtS, TRLDLtS]
#solvers = [TRLDLt_abs, TRLDLtNew, TRLDLt_absNew]
#solvers = [TRMA57_absNew, TRMA57_absNew]
labels = []
for s in solvers push!(labels,convert(String,(last(rsplit(string(s),"."))))) end

labels[4] = string(labels[4],"Monotone")
stp = TStopping(atol = atol, rtol = rtol, max_iter = 1000000, max_eval = 1000000, max_time = 100.0)

options = [
           Dict{Symbol,Any}(:verbose=>false, :stp => stp)
           Dict{Symbol,Any}(:verbose=>false, :stp => stp)
           Dict{Symbol,Any}(:verbose=>false, :stp => stp)
           Dict{Symbol,Any}(:verbose=>false, :stp => stp, :monotone => true)
           Dict{Symbol,Any}(:verbose=>false, :stp => stp)
           Dict{Symbol,Any}(:verbose=>false, :stp => stp)
           Dict{Symbol,Any}(:verbose=>false, :stp => stp)
           Dict{Symbol,Any}(:verbose=>false, :stp => stp)
           Dict{Symbol,Any}(:verbose=>false, :s => stp)
           Dict{Symbol,Any}(:verbose=>false, :max_iter => 100000,  :max_eval => 100000, :atol=> atol, :rtol => rtol)#, :robust
           ]


include("../compare_solvers.jl")

s1, P1, t1, Pt1 = compare_solvers_with_options2(solvers, options, labels, test_probs, n_min, n_max, printskip = false)

TestCUTEst && include("CleanCUTE.jl")
