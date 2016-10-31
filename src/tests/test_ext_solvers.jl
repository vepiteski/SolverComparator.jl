using OptimizationProblems
using JuMP
using NLPModels
using AmplNLReader



# Optimize  --  two solvers,  trunk (:HesVec) and lbfgs (only :Grad)
using Optimize

# official julia packages:  NLopt and Ipopt
include("../ExtSolvers/solvers.jl")


# Other packages available

# L-BFGS-B  --  one solver; uses only :Grad
# uncomment if you have access to L-BFGS-B
#using Lbfgsb
#include("../ExtSolvers/L-BFGS-B.jl")

Ext_solvers = NLoptSolvers ∪ IpoptSolvers# ∪ [LbfgsB]

model = MathProgNLPModel(genrose(2))

for s in Ext_solvers
    @printf(" executing solver %s on JuMP genrose(2)\n",string(s))
    (x, f, gNorm, iterB, optimal, tired, status) = s(model)
    @printf("x* = ");show(x);@printf("   f* =  %d",f);@printf("\n")
end

cmd_dir, bidon = splitdir(@__FILE__())
ampl_dir = string(cmd_dir,"/../ampl")
model = AmplModel(string(ampl_dir,"/rosenbr"))

for s in Ext_solvers
    @printf(" executing solver %s on Ampl rosenbr\n",string(s))
    (x, f, gNorm, iterB, optimal, tired, status) = s(model)
    @printf("x* = ");show(x);@printf("   f* =  %d",f);@printf("\n")
end

