using JuMP
using MathProgBase
using NLPModels

using AmplNLReader
ampl_dir, bidon = splitdir(@__FILE__())

include("braxyMod.jl")
include("brayMod.jl")
n=128

variants = [bray,braxy]

for v in variants

    # First test the MPB model
    nlp1 = MathProgNLPModel(v(n));


    nvar = nlp1.meta.nvar
    x1 = nlp1.meta.x0
    @printf(" model %s  \n",string(v))
    # Evaluate  the MPB version
    @printf(" JuMP  nvar = %7d\n", nvar)
    f1 = obj(nlp1,x1)
    @printf("f(x₀) = %15.7e\n", f1)
    g1 = grad(nlp1, x1)
    @printf("‖∇f(x₀)‖ = %7.1e\n", norm(g1))
    gHg1 = dot(g1, hprod(nlp1, x1, g1))
    @printf("∇f(x₀)ᵀ ∇²f(x₀) ∇f(x₀) = %8.1e\n", gHg1)

    # AMPL version
    nlp2 = AmplModel(string(ampl_dir,"/",v))
    nvar = nlp2.meta.nvar
    x2 = nlp2.meta.x0
    
    # Evaluate the AMPL version
    @printf(" Ampl  nvar = %7d\n", nvar)
    f2 = obj(nlp2,x2)
    @printf("f(x₀) = %15.7e\n", f2)
    g2 = grad(nlp2, x2)
    @printf("‖∇f(x₀)‖ = %7.1e\n", norm(g2))
    gHg2 = dot(g2, hprod(nlp2, x2, g2))
    @printf("∇f(x₀)ᵀ ∇²f(x₀) ∇f(x₀) = %8.1e\n", gHg2)

    # Assess that both version compute identical f,g,Hv at the initial point
    @test x1 == x2
    @test f1 ≈ f2
    @test g1 ≈ g2
    @test gHg1 ≈ gHg2

end
