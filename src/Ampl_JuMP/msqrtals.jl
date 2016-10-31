# AMPL Model by Hande Y. Benson
#
# Copyright (C) 2001 Princeton University
# All Rights Reserved
#
# Permission to use, copy, modify, and distribute this software and
# its documentation for any purpose and without fee is hereby
# granted, provided that the above copyright notice appear in all
# copies and that the copyright notice and this
# permission notice appear in all supporting documentation.                     

#   Source:  problem 201 (p. 93) in
#   A.R. Buckley,
#   "Test functions for unconstrained minimization",
#   TR 1989CS-3, Mathematics, statistics and computing centre,
#   Dalhousie University, Halifax (CDN), 1989.

#   SIF input: Ph. Toint, Dec 1989.

#   classification SUR2-AN-V-V

# JuMP version, JP Dussault Sherbrooke October 2016

export msqrtals
function msqrtals()
    nlp = Model()

    P = 32;
    N = P^2;
    B= [ sin( ((i-1)*P + j)^2 ) for i=1:P, j=1:P]
    #A =[ sum( B[i,k]*B[k,j], k=1:P), for i=1:P, j=1:P];
    A = B*B

    @variable(nlp, x[i = 1:P, j = 1:P], start =  0.2*B[i,j]);

    @NLobjective(
                 nlp,
                 Min,
                 sum{sum{
                         (sum{x[i,t]*x[t,j], t=1:P}-A[i,j])^2,
                 i = 1:P}, j = 1:P}
                 )
    return nlp
end
