using SolverComparator
using Base.Test

println("testing new ampl models")
include("../src/Ampl_JuMP/test_bra.jl")
include("../src/Ampl_JuMP/test_msqrtals.jl")

println("testing external solvers from IPOpt and NLOpt")

include("../src/ExtSolvers/test_ext_solvers.jl")

println("testing the comparator tools")
include("../src/tests/testcompare.jl")
