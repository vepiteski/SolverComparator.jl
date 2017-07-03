using MathProgBase
# Solvers are interfaced thru MathProgBase

# NLopt (7 gradient based solvers)
using NLopt
include("NLoptSolvers.jl")

# Ipopt  --  2 solvers  (true hessian (uses :Hess) and limited memory approximation (needs only :Grad))
IpoptSolvers = Function[]

using Ipopt
include("Ipopt_LBFGSMPB.jl")
push!(IpoptSolvers,Ipopt_LBFGSMPB)

include("Ipopt_LBFGSMPBS.jl")
push!(IpoptSolvers,Ipopt_LBFGSMPBS)

include("Ipopt_NMPB.jl")
push!(IpoptSolvers,Ipopt_NMPB)

include("Ipopt_NMPBS.jl")
push!(IpoptSolvers,Ipopt_NMPBS)

# trunk   with signature standardized
include("trunk.jl")
