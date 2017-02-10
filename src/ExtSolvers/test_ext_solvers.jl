#using OptimizationProblems
using JuMP
using NLPModels
#using AmplNLReader



# Optimize  --  two solvers,  trunk (:HesVec) and lbfgs (only :Grad)
# using Optimize

# official julia packages:  NLopt and Ipopt
include("solvers.jl")

# Other packages available

# L-BFGS-B  --  one solver; uses only :Grad
# uncomment if you have access to L-BFGS-B
#using Lbfgsb
#include("../ExtSolvers/L-BFGS-B.jl")

using SolverComparator

Ext_solvers = IpoptSolvers ∪ NLoptSolvers  # ∪ [LbfgsB]
include("genrose.jl")

for s in Ext_solvers
    @printf(" executing solver %s on JuMP genrose(2)\n",string(s))
    model = MathProgNLPModel(genrose(2))
    (x, f, gNorm, iterB, optimal, tired, status) = eval(s)(model)
    @printf("x0 = ");show(model.meta.x0);@printf("x* = ");show(x);@printf("   f* =  %d",f);@printf("\n")
    
    @test f ≈ 1.0

    finalize(model)
end


# For the moment, ampl complains about AmplException("Error while evaluating constraints Jacobian")
#
# It is a bug on my setup Ubuntu 14.04.
#
#
#cmd_dir, bidon = splitdir(@__FILE__())

#for s in Ext_solvers
#    model = AmplModel(string(cmd_dir,"/genrose"))
#    @printf(" executing solver %s on Ampl genrose\n",string(s))
#    (x, f, gNorm, iterB, optimal, tired, status) = s(model)
#    @printf("x0 = ");show(model.meta.x0);@printf("x* = ");show(x);@printf("   f* =  %d",f);@printf("\n")
#    finalize(model)
#end

@static if is_unix()
    using CUTEst
    for s in Ext_solvers
        model = CUTEstModel("ROSENBR")
        @printf(" executing solver %s on CUTEst rosenbr\n",string(s))
        (x, f, gNorm, iterB, optimal, tired, status) = eval(s)(model)
        @printf("x0 = ");show(model.meta.x0);@printf("x* = ");show(x);@printf("   f* =  %d",f);@printf("\n")
        @test f < 1e-10

        finalize(model)
    end
    lib_so_files = [f for f in filter(x -> contains(x,".so"),readdir())]
    for str in lib_so_files run(`rm $str `) end
    run(`rm AUTOMAT.d`)
    run(`rm OUTSDIF.d`)
end
