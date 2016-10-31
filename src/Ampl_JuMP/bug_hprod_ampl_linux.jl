using AmplNLReader
#nlp = AmplModel("../ampl/msqrtals")  # loads the msqrtals.nl model
nlp = AmplModel("../ampl/curly10")  # loads the msqrtals.nl model
nvar = nlp.meta.nvar
x0 = nlp.meta.x0

Hg = copy(x0) # allocate once

nbt=100000
@printf("evaluating %d times the Hv product\n",nbt)
for i=1:nbt
    Hg = hprod!(nlp, x0, x0, Hg)
end
println("done")

# consume ~7.3 Gb  memory
# gc() frees nothing
# executing a second time eventually reaches my 16 Gb and begin swapping
