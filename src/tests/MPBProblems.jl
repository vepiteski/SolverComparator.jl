
using OptimizationProblems


probs = filter(name -> name != :OptimizationProblems
                   && name != :sbrybnd
                   && name != :penalty2
                   && name != :penalty3
               , names(OptimizationProblems))

# probs = [:arwhead]

mpb_probs = (MathProgNLPModel(eval(p)(n_max),  name=string(p) )   for p in probs)
