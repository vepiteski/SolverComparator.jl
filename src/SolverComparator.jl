module SolverComparator

#using OptimizationProblems
using JuMP
using NLPModels
using AmplNLReader

#using Optimize

include("compare_solvers.jl")
export compare_solvers, compare_solvers_Ampl, compare_solvers_CUTEst

end # module
