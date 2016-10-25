module SolverComparator

using OptimizationProblems
using JuMP
using NLPModels

using Optimize

include("compare_solvers.jl")
export compare_solvers, compare_solvers_Ampl

include("solvers.jl")


end # module
