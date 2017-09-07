using Optimize
using SolverComparator
using JLD
using Plots
pyplot()

d=load("test.jld")
args=Dict()
args[:reuse] = false
args[:title] = " f + g + H*v + H evaluations"
#include("../profile_solvers2.jl")

profiles = profile_solvers(d["s1"]; args...)

args[:title] = " CPU time"

profiles_time = profile_solvers(d["t1"]; args...)

