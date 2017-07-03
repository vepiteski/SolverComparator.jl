using Optimize
using SolverComparator
using NLPModels



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

# CUTEst collection
# include("CUTEstProblems.jl")
# test_probs = cute_probs


# Select solvers

# official julia packages:  NLopt and Ipopt
include("../ExtSolvers/solvers.jl")

# Other packages available

# L-BFGS-B  --  one solver; uses only :Grad
#using Lbfgsb
#include("../ExtSolvers/L-BFGS-B.jl")

# Optimize  --  two solvers,  trunk (:HesVec) and lbfgs (only :Grad)
#using Optimize

using LSDescentMethods
using LineSearch
using ARCTR
using Stopping


stop_norm = ARCTR.stop_norm

# solvers = [ ST_TROp,   Newtrunk,   ARCqKOp,  Newton]
solvers = [CG_PRS, CG_PRS, CG_PRS, CG_PRS, CG_PRS, CG_PRS, CG_PRS]
labels = []
for s in solvers push!(labels,convert(String,(last(rsplit(string(s),"."))))) end

stop = TStopping(max_eval = 50_000, max_iter = 10_000)#, atol = 1e-4, rtol = 1e-5)

τ₀ = 0.48
τ₁ = 0.49
additional_step = true
δ = 1_000.0
symm = false
epsillon1 = 0.1
epsillon2 = 0.7

options = [Dict{Symbol,Any}(:verbose => false, :stp => stop,
                            :linesearch => Biss_Nwt_ls, :τ₀ => τ₀,
                            :τ₁ => τ₁, :add_step => additional_step,
                            :check_slope => true)
           Dict{Symbol,Any}(:verbose => false, :stp => stop,
                            :linesearch => Biss_Sec_ls, :τ₀ => τ₀,
                            :τ₁ => τ₁, :add_step => additional_step,
                            :check_slope => true)
           Dict{Symbol,Any}(:verbose => false, :stp => stop,
                            :linesearch => Biss_SecA_ls, :τ₀ => τ₀,
                            :τ₁ => τ₁, :add_step => additional_step,
                            :check_slope => true)
           Dict{Symbol,Any}(:verbose => false, :stp => stop,
                            :linesearch => Biss_Cub_ls, :τ₀ => τ₀,
                            :τ₁ => τ₁, :add_step => additional_step,
                            :check_slope => true)
           Dict{Symbol,Any}(:verbose => false, :stp => stop,
                            :linesearch => Biss_ls, :τ₀ => τ₀,
                             :τ₁ => τ₁, :add_step => additional_step,
                            :check_slope => true)
           Dict{Symbol,Any}(:verbose => false, :stp => stop, :τ₀ => 0.0001,
                            :τ₁ => 0.001, :linesearch => Newarmijo_wolfe,
                            :check_slope => true)
           Dict{Symbol,Any}(:verbose => false, :stp => stop, :τ₀ => 0.0001,
                            :τ₁ => 0.001, :linesearch => _hagerzhang2!,
                            :linesearchmax => 50, :mayterminate => true)
           ]

for i=1:size(labels)[1]
  labels[i] = string(labels[i], string(" ", convert(String, (last(rsplit(string(options[i][:linesearch]), "."))))))
end

# for i=1:5 #size(labels)[1]
#   labels[i] = string(labels[i], string(" ", string(options[i][:eps1])))
# end

include("../compare_solvers.jl")

s1, P1, t1, Pt1 = compare_solvers_with_options2(solvers, options, labels, test_probs, n_min, n_max, printskip = false)
