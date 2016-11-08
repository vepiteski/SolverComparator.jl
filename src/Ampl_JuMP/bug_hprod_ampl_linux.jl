using AmplNLReader
nlp = AmplModel("msqrtals")  # loads the msqrtals.nl model

#using JuMP
#using NLPModels
#  For comparison, the JuMP version is OK
#include("msqrtals.jl")
#nlp = MathProgNLPModel(msqrtals())

nvar = nlp.meta.nvar
x0 = nlp.meta.x0

Hg = copy(x0) # allocate once
v = copy(x0)
f = obj(nlp,x0)
g = grad(nlp,x0)    
Hg = hprod!(nlp, x0, x0, Hg)
println(" f(x0) = $f ")

function test_memory_leak!(nbt,nlp,x0,v,Hg)
    @printf("evaluating %d times the Hv product\n",nbt)
    for i=1:nbt
        Hg = hprod!(nlp, x0, v, Hg)
    end
    println("done")
end

@profile test_memory_leak!(1000,nlp,x0,v,Hg)

# for nbt = 10000, consume ~7.3 Gb  memory
# gc() frees nothing
# executing a second time eventually reaches my 16 Gb and begin swapping
