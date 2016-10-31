using NLPModels
using AmplNLReader



# Optimize  --  two solvers,  trunk (:HesVec) and lbfgs (only :Grad)
#using Optimize

using SolverComparator

using ARCTR

model = AmplModel("../ampl/aircrftb")
ST_TRsparse(model)#  to have trunk compiled

model = AmplModel("../ampl/drcavty1")
@time ST_TRsparse(model)
