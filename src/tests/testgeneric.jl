using Optimize
#using BenchmarkProfiles
#using SolverComparator
using NLPModels

using Plots
pyplot()

# select problem collection

n_min = 20
n_max = 50

TestCUTEst = false

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
#TestCUTEst = true


# Select solvers

using Stopping

# official julia packages:  NLopt and Ipopt
include("../ExtSolvers/solversS.jl")

# Other packages available

# L-BFGS-B  --  one solver; uses only :Grad
#using Lbfgsb
#include("../ExtSolvers/L-BFGS-B.jl")

using ARCTR
using LSDescentMethods

atol=1.0e-5
rtol=1.0e-10



#######################################
#
#  Several comparison examples
#
######################################

#solvers = [ARCMA57_absS,TRMA57_absS]
#solvers = [TRKOpS, ARCqKOpS, ST_TROpS,LbfgsB]
solvers = [ST_TROpS, ARCqKOpS, NewtrunkS, NewtrunkS]
#solvers = [TRMA57_absS, ARCMA57_absS, TRMA57S, ARCMA57S, TRMA97_absS, ARCMA97_absS, TRMA97S, ARCMA97S, Ipopt_NMPBS]
#solvers = [ARCMA57_absS, ARCMA97_absS, ARCSpectral_absS,ARCLDLt_absS]
#solvers = [TRMA97_absS, ARCMA97_absS, TRMA97S, ARCMA97S, Ipopt_NMPBS]
#solvers = [ST_TROpS, ARCqKOpS, LbfgsBS, Ipopt_LBFGSMPBS]
#solvers = [TRLDLt_absS, ARCLDLt_absS, ARCLDLtS, TRLDLtS]


#################
#
# provide options
#
################
stp = TStopping(atol = atol, rtol = rtol, max_iter = 1000000, max_eval = 1000000, max_time = 100.0)

options = [
           Dict{Symbol,Any}(:verbose=>false, :stp => stp)
           Dict{Symbol,Any}(:verbose=>false, :stp => stp)
           Dict{Symbol,Any}(:verbose=>false, :stp => stp)
           Dict{Symbol,Any}(:verbose=>false, :stp => stp, :monotone => true)
           ]


####################
#
# strip the solver's name from its module prefix
#
###################
labels = []
for s in solvers push!(labels,convert(String,(last(rsplit(string(s),"."))))) end

##################
#
# in case of identical solvers with distinc options, edit the solver's name to avoid identical labels
#
#################
labels[4] = string(labels[4],"Monotone")



include("../compare_solvers.jl")

s1, P1, t1, Pt1 = compare_solvers_with_options2(solvers, options, labels, test_probs, n_min, n_max, printskip = false)


TestCUTEst && include("CleanCUTE.jl")
