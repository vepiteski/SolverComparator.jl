using CUTEst

probs = open(readlines,"../CUTEstUnc.list")
probs = filter(
    x -> x != "MSQRTALS\n"  # very long to solve
    && x != "MSQRTBLS\n",   # very long to solve
    probs)

cute_probs = (CUTEstModel(p)  for p in probs)

