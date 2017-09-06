module SolverComparator

#using OptimizationProblems
using JuMP
using NLPModels
using AmplNLReader
using Stopping

#using Optimize

include("compare_solvers.jl")
#export compare_solvers

include("ExtSolvers/solversS.jl")


end # module
