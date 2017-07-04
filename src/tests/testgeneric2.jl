using Optimize
using SolverComparator
using NLPModels

using Plots
pyplot()


# select problem collection

n_min = 2
n_max = 200

# For the moment, impossible to mix collections
# Uncomment only one of mpb, ampl or cutest

# Math Prog Base collection
include("MPBProblems.jl")
test_probs = mpb_probs

# Ampl collection
# include("AmplProblems.jl")
# test_probs = ampl_probs

# # CUTEst collection
# include("CUTEstProblems.jl")
# test_probs = cute_probs

using Stopping

# Select solvers

# official julia packages:  NLopt and Ipopt
# include("../ExtSolvers/solvers.jl")

# Other packages available

# L-BFGS-B  --  one solver; uses only :Grad
#using Lbfgsb
#include("../ExtSolvers/L-BFGS-B.jl")

# Optimize  --  two solvers,  trunk (:HesVec) and lbfgs (only :Grad)
#using Optimize

using LSDescentMethods
println("ici!")
using LineSearch
using ARCTR
using Stopping


stop_norm = ARCTR.stop_norm

# solvers = [ ST_TROp,   Newtrunk,   ARCqKOp,  Newton]
solvers = [CG_FRS, CG_FRS, CG_FRS, CG_FRS, CG_FRS, CG_FRS]
# solvers = [NewtonS, NewtonS, NewtonS, NewtonS, NewtonS, NewtonS]
labels = []
for s in solvers push!(labels,convert(String,(last(rsplit(string(s),"."))))) end

stop = TStopping(max_eval = 40_000)#, max_iter = 50_000)#, atol = 1e-4, rtol = 1e-5)

τ₀ = 0.00001
τ₁ = 0.001
additional_step = true
δ = 1_000.0
symm = false
epsillon1 = 0.1
epsillon2 = 0.7
ver_slope = true

options = [Dict{Symbol,Any}(:verbose => false, :stp => stop,
                            :linesearch => TR_Sec_ls, :τ₀ => τ₀,
                            :τ₁ => τ₁, :verboseLS => false, :Δ => 1_000.0,
                            :verbose => false, :add_step => additional_step,
                            :symetrique => symm,
                            :eps1 => epsillon1, :eps2 => epsillon2,
                            :check_slope => ver_slope)
           Dict{Symbol,Any}(:verbose => false, :stp => stop,
                            :linesearch => TR_SecA_ls, :τ₀ => τ₀, :Δ => 1_000.0,
                            :τ₁ => τ₁, :add_step => additional_step,
                            :symetrique => symm,
                            :eps1 => epsillon1, :eps2 => epsillon2,
                            :check_slope => ver_slope)
           Dict{Symbol,Any}(:verbose => false, :stp => stop, :Δ => 10.0,
                            :linesearch => TR_Cub_ls, :τ₀ => τ₀,
                            :τ₁ => τ₁, :add_step => additional_step,
                            :symetrique => symm, :eps1 => 0.001, :eps2 => 0.01,
                            :check_slope => ver_slope)
           Dict{Symbol,Any}(:verbose => false, :stp => stop, :Δ => 1_000.0,
                            :linesearch => TR_Nwt_ls, :τ₀ => τ₀,
                            :τ₁ => τ₁, :add_step => additional_step,
                            :symetrique => symm,
                            :eps1 => epsillon1, :eps2 => epsillon2,
                            :check_slope => ver_slope)
           Dict{Symbol,Any}(:verbose => false, :stp => stop, :τ₀ => τ₀,
                            :τ₁ => τ₁, :linesearch => Newarmijo_wolfe,
                            :check_slope => ver_slope)
           Dict{Symbol,Any}(:verbose => false, :stp => stop, :τ₀ => τ₀,
                            :τ₁ => τ₁, :linesearch => _hagerzhang2!,
                            :linesearchmax => 50, :mayterminate => true)
           ]

for i=1:size(labels)[1]
  labels[i] = string(labels[i], string(" ", convert(String, (last(rsplit(string(options[i][:linesearch]), "."))))))
end

# for i=1:5 #size(labels)[1]
#   labels[i] = string(labels[i], string(" ", string(options[i][:eps1])))
# end

include("../compare_solversLS.jl")

s1, P1, t1, Pt1 = compare_solvers_with_options2(solvers, options, labels, test_probs, n_min, n_max, printskip = false)
