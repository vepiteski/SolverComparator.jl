# SolverComparator

A few scripts to compare optimization solvers from various sources. Comparisons are performed in the NLPModel framework. 

For now, only unconstrained optimization is considered. Supported solvers are variants from
- NLopt (7 gradient based variants)
- Ipopt (full hessian and limited memory approximation variants)
- Optimize (trunk and lbfgs)
- ARCTR (20 variants, 4 more using the MA97 HSL package available)

