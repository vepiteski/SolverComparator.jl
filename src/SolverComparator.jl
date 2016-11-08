module SolverComparator

#using OptimizationProblems
using JuMP
using NLPModels
using AmplNLReader

using Optimize

include("compare_solvers.jl")
export compare_solvers

include("ExtSolvers/solvers.jl")


end # module
