using NLPModels
using AmplNLReader



# Optimize  --  two solvers,  trunk (:HesVec) and lbfgs (only :Grad)
using Optimize

#model = AmplModel("ampl/aircrftb")
#trunk(model)#  to have trunk compiled

#model = AmplModel("ampl/msqrtals")
#@time trunk(model)


using OptimizationProblems
model = MathProgNLPModel(genrose(5))
trunk(model)#  to have trunk compiled

model = AmplModel("Ampl_JuMP/msqrtals")
#model = MathProgNLPModel(msqrtals())
@time trunk(model)
