using Optimize
using SolverComparator
using OptimizationProblems
using NLPModels


# Other packages available

# L-BFGS-B  --  one solver; uses only :Grad
using Lbfgsb
include("../ExtSolvers/L-BFGS-B.jl")


# Optimize  --  two solvers,  trunk (:HesVec) and lbfgs (only :Grad)

n=200

probs = filter(name -> name != :OptimizationProblems 
                   && name != :sbrybnd
                   && name != :penalty2
                   && name != :penalty3
               , names(OptimizationProblems))


mpb_probs = (MathProgNLPModel(eval(p)(n),  name=string(p) )   for p in probs)
tst_prob = MathProgNLPModel(eval(:woods)(n),  name=string(:woods) );



n_min = 0  # not used, OptimizationProblems may be adjusted
n_max = n

using LSDescentMethods
using LineSearch
#solver = Newlbfgs
#solver = steepest
#solver = NewtonLDLt
#solver = CG_FR
solver = CG_PR
#solver = CG_HZ
#solver = CG_HS
#(x, f, ∇fNorm, iter, optimal, tired, status)=solver(tst_prob)

include("../compare_solvers.jl")

using ARCTR
using HSL

#solvers = [CG_PR,CG_PR,CG_HZ,CG_HZ,LbfgsB,Newlbfgs]
#solvers = [CG_FR,CG_PR,CG_HS,CG_HZ,LbfgsB]
#labels = ["PR","PR .1 .9","HZ basicLS .1 .9","HZ basicLS","LbfgsB","Newlbfgs"]
#labels = ["Fletcher-Reeves","Polak-Ribiere","Hestenes-Stiefel","Hager-Zhang","NewLbfgs"]
#options = [Dict{Symbol,Any}(:τ₀=>0.001, :τ₁=> 0.02, :verbose=>false, :verboseLS=>false) 
#           Dict{Symbol,Any}(:linesearch => TR_Sec_ls, :τ₀=>0.001, :τ₁=>0.02, :verbose=>false, :verboseLS=>false) 
#           Dict{Symbol,Any}(:linesearch => TR_Sec_ls,:τ₀=>0.3, :τ₁=> 0.6, :verbose=>false, :verboseLS=>false) 
#           Dict{Symbol,Any}(:linesearch => TR_SecA_ls,:τ₀=>0.001, :τ₁=> 0.02, :verbose=>false, :verboseLS=>false) 
#           Dict{Symbol,Any}( :verbose=>false, :verboseLS=>false) ]

#solvers = [NewtonMA57, Newlbfgs, ARCMA57_abs, TRMA57_abs, LbfgsB]
#labels = ["NewtonMA57", "lbfgs", "ARCMA57_abs", "TRMA57_abs", "LbfgsB"]
#solvers = [ NewtonMA57,   NewtonLDLt,   ARCMA57_abs,   TRMA57_abs,   ARCLDLt_abs]
#labels =  ["NewtonMA57", "NewtonLDLt", "ARCMA57_abs", "TRMA57_abs", "ARCLDLt_abs"]
#solvers = [ NewtonMA57,   NewtonSpectral,   ARCMA57_abs,   TRMA57_abs,   ARCSpectral_abs]
#labels =  ["NewtonMA57", "NewtonSpectral", "ARCMA57_abs", "TRMA57_abs", "ARCSpectral_abs"]

solvers = [NewtonSpectral, ARCSpectral,TRSpectral, ARCSpectral_abs, TRSpectral_abs]
labels = ["NewtonSpectral", "ARCSpectral", "TRSpectral", "ARCSpectral_abs", "TRSpectral_abs"]

options = [Dict{Symbol,Any}(:verbose=>false, :verboseLS=>false, :atol=> 1.0e-5, :rtol => 1.0e-10)
           Dict{Symbol,Any}(:verbose=>false, :atol=> 1.0e-5, :rtol => 1.0e-10) 
           Dict{Symbol,Any}(:verbose=>false, :atol=> 1.0e-5, :rtol => 1.0e-10) 
           Dict{Symbol,Any}(:verbose=>false, :atol=> 1.0e-5, :rtol => 1.0e-10) 
           Dict{Symbol,Any}(:verbose=>false, :atol=> 1.0e-5, :rtol => 1.0e-10)
           ]

#options = [Dict{Symbol,Any}(:verbose=>false, :verboseLS=>false) 
#           Dict{Symbol,Any}(:verbose=>false, :verboseLS=>false) 
#           Dict{Symbol,Any}(:verbose=>false) 
#           Dict{Symbol,Any}(:verbose=>false)  
#           Dict{Symbol,Any}(:verbose=>false) ] # The basic greedy line search

#options = [Dict{Symbol,Any}(:linesearch => TR_Sec_ls, :τ₀=>0.001, :τ₁=>0.02, :verbose=>false, :verboseLS=>false) 
#           Dict{Symbol,Any}(:linesearch => TR_Sec_ls, :τ₀=>0.1, :τ₁=>0.9, :verbose=>false, :verboseLS=>false) 
#           Dict{Symbol,Any}(:linesearch => TR_Sec_ls, :verbose=>false, :τ₀=>0.1, :τ₁=>0.9, :verboseLS=>false)
#           Dict{Symbol,Any}(:verbose=>false, :τ₀=>0.1, :τ₁=>0.9, :verbose=>false, :verboseLS=>false)
#           Dict{Symbol,Any}(:verbose=>false)
#           Dict{Symbol,Any}(:verbose=>false)]  # :scaling=>true) 



#           Dict{Symbol,Any}() ]

#options = [Dict{Symbol,Any}(:linesearch => TR_Sec_ls, :τ₀=>0.3, :τ₁=> 0.6) 
#           Dict{Symbol,Any}(:τ₀=>0.3, :τ₁=> 0.6) 
#           Dict{Symbol,Any}(:linesearch => TR_Sec_ls, :τ₀=>0.45, :τ₁=>0.56) 
#           Dict{Symbol,Any}()  ] # The basic greedy line search


s1, P1, t1, Pt1 = compare_solvers_with_options2(solvers, options, labels, mpb_probs, n_min, n_max)

#s1, P1 = compare_solver_options(solver, options, mpb_probs, n_min, n_max)
