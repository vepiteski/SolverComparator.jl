# NLopt (7 gradient based solvers)
using NLopt
include("NLoptSolvers.jl")

# Ipopt  --  2 solvers  (true hessian (uses :Hess) and limited memory approximation (needs only :Grad))
IpoptSolvers = Function[]

using Ipopt
include("Ipopt_LBFGSMPB.jl")
push!(IpoptSolvers,Ipopt_LBFGSMPB)
include("Ipopt_NMPB.jl")
push!(IpoptSolvers,Ipopt_NMPB)
