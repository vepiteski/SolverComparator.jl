using OptimizationProblems
using JuMP
using NLPModels
using AmplNLReader



# Optimize  --  two solvers,  trunk (:HesVec) and lbfgs (only :Grad)
using Optimize

model = MathProgNLPModel(penalty2(10))
trunk(model) #  to have trunk compiled

model = MathProgNLPModel(penalty2(10000))
@time trunk(model)
