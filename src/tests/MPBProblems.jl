
using OptimizationProblems


probs = filter(name -> name != :OptimizationProblems
               #&& name != :arglina
               && name != :arglinb
               #&& name != :arglinc
               #&& name != :vardim
               #&& name != :sbrybnd
               && name != :penalty2
               && name != :penalty3
               , names(OptimizationProblems))

#probs = [:curly10]

mpb_probs = (MathProgNLPModel(eval(p)(n_max),  name=string(p) )   for p in probs)
