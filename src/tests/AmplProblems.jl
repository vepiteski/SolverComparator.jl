# loads Ampl problems
using AmplNLReader

ampl_prob_dir = "../ampl/"
probs = [Symbol(split(p, ".")[1]) for p in filter(x -> contains(x, ".nl") 
                                                  && x != "hs068.nl"
                                                  && x != "hs069.nl"
                                                  && x != "drcavty1.nl"
                                                  && x != "drcavty2.nl"
                                                  && x != "drcavty3.nl"
                                                  && x != "msqrtals.nl"
                                                  && x != "msqrtbls.nl",
                                                       readdir(ampl_prob_dir))]

ampl_probs = (AmplModel(string(ampl_prob_dir,p) )  for p in probs)
