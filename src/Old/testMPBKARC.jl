using Optimize
using SolverComparator
using OptimizationProblems
using NLPModels


# official julia packages:  NLopt and Ipopt
include("../ExtSolvers/solvers.jl")


# Other packages available

# L-BFGS-B  --  one solver; uses only :Grad
using Lbfgsb
include("../ExtSolvers/L-BFGS-B.jl")


# Optimize  --  two solvers,  trunk (:HesVec) and lbfgs (only :Grad)
using Optimize

n=500
probs = filter(name -> name != :OptimizationProblems 
                   && name != :sbrybnd
                   && name != :penalty2
                   && name != :penalty3, names(OptimizationProblems))

# ARCTR  --  24 solvers (use at least :HessVec, some :Hess)
using ARCTR
stop_norm = ARCTR.stop_norm

mpb_probs = (MathProgNLPModel(eval(p)(n),  name=string(p) )   for p in probs)
sprob = :broydn7d
tst_prob = MathProgNLPModel(eval(sprob)(n),  name=string(sprob) );
#mpb_probs = [tst_prob]

#using LSDescentMethods  # For NewtonLDLt

#solvers1 = [ARCLDLt,   TRLDLt,   ARCLDLt_abs,   TRLDLt_abs] #,  NewtonLDLt]
#labels =  ["ARCLDLt", "TRLDLt", "ARCLDLt_abs", "TRLDLt_abs"]#, "NewtonLDLt"]
#solvers1 = [ARCSpectral,   TRSpectral,   ARCSpectral_abs,   TRSpectral_abs] #,  NewtonSpectral]
#labels =  ["ARCSpectral", "TRSpectral", "ARCSpectral_abs", "TRSpectral_abs"]#, "NewtonSpectral"]
#solvers1 = [ARCLDLt,   ARCLDLt_abs,   ARCSpectral,   ARCSpectral_abs,   ARCMA57,   ARCMA57_abs] #,  NewtonLDLt]
#labels  = ["ARCLDLt", "ARCLDLt_abs", "ARCSpectral", "ARCSpectral_abs", "ARCMA57", "ARCMA57_abs"]#, "NewtonLDLt"]
#solvers1 = [ARCMA57,   ARCMA57_abs,    LbfgsB] #, NewtonLDLt]
#labels =  ["ARCMA57", "ARCMA57_abs",  "LbfgsB"]#, "NewtonLDLt"]
solvers1 = [ARCMA57,   ARCMA57_abs ,  ST_TROp,   Newtrunk,        ARCqKOp,   Newtrunk] #, NewtonLDLt]
labels =  ["ARCMA57", "ARCMA57_abs", "ST_TROp", "Newtrunk mono", "ARCqKOp", "Newtrunk"]#, "NewtonLDLt"]
#solvers1 = [ARCMA97,   ARCMA97_abs,    LbfgsB] #, NewtonLDLt]
#labels =  ["ARCMA97", "ARCMA97_abs",  "LbfgsB"]#, "NewtonLDLt"]
#solvers1 = [ARCMA57,   ARCMA57_abs,   TRMA57,   TRMA57_abs,   NewtonMA57,   Ipopt_NMPB]
#labels =  ["ARCMA57", "ARCMA57_abs", "TRMA57", "TRMA57_abs", "NewtonMA57", "Ipopt_NMPB"]
 
#solvers1 = [ARCMA57_abs,   NewtonMA57,   Ipopt_NMPB]
#labels =  ["ARCMA57_abs", "NewtonMA57", "Ipopt_NMPB"]

n_min = 0  # not used, OptimizationProblems may be adjusted
n_max = n

include("../compare_solvers.jl")
options = [Dict{Symbol,Any}(:verbose=>false, :itmax => 10000, :atol=> 1.0e-5, :rtol => 1.0e-10) 
           Dict{Symbol,Any}(:verbose=>false, :itmax => 10000, :atol=> 1.0e-5, :rtol => 1.0e-10) 
           Dict{Symbol,Any}(:verbose=>false, :itmax => 10000, :atol=> 1.0e-5, :rtol => 1.0e-10) 
           Dict{Symbol,Any}(:verbose=>false, :itmax => 10000, :atol=> 1.0e-5, :rtol => 1.0e-10, :monotone => true)
           Dict{Symbol,Any}(:verbose=>false, :itmax => 10000, :atol=> 1.0e-5, :rtol => 1.0e-10)
           Dict{Symbol,Any}(:verbose=>false, :itmax => 10000, :atol=> 1.0e-5, :rtol => 1.0e-10)
           Dict{Symbol,Any}(:verbose=>false, :itmax => 10000, :atol=> 1.0e-5, :rtol => 1.0e-10)
           ]


s1, P1, t1, Pt1 = compare_solvers_with_options2(solvers1, options, labels, mpb_probs, n_min, n_max, title = "First order: #f + #g ", printskip = false)
