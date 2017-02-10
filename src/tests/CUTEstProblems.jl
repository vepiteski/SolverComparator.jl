using CUTEst

probs = open(readlines,"CUTEstUnc.list")

cute_probs = (CUTEstModel(p)  for p in probs)

