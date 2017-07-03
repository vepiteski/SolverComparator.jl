
using OptimizationProblems

probs = filter(name -> name != :OptimizationProblems 
               #&& name != :sbrybnd
               #&& name != :penalty2
               #&& name != :penalty3
               #&& name != :cliff
               #&& name != :meyer3
               #&& name != :nasty
               , names(OptimizationProblems))

mpb_probs = (MathProgNLPModel(eval(p)(n_max),  name=string(p) )   for p in probs)

