module SolverComparator

using OptimizationProblems
using JuMP
using NLPModels

using Optimize

include("compare_solvers.jl")
export compare_solvers

include("solvers.jl")


end # module
