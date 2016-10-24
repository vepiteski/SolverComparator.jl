# NLopt (7 gradient based solvers)
using NLopt
include("NLoptSolvers.jl")

# Ipopt  --  2 solvers  (true hessian (uses :Hess) and limited memory approximation (needs only :Grad))
using Ipopt
include("Ipopt_LBFGSMPB.jl")
include("IpoptMPB.jl")

