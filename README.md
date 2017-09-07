# SolverComparator

A few scripts to compare optimization solvers from various sources. Comparisons are performed in the NLPModel framework. Also, some additional problems are provided. All solvers are interfaced to use the Stopping Pkg to uniformize the stopping criteria in the comparisons.

For now, only unconstrained optimization is considered. Supported solvers are variants from
- NLopt (7 gradient based variants)
- Ipopt (full hessian and limited memory approximation variants)
- Knitro (untested)
- Optimize (trunk and lbfgs)
- ARCTR (20 variants, 4 more using the MA97 HSL package available)
- LSDescentMethods (various conjugate gradients, modified Newton)

src/ExtSolvers contains wrappers to solvers from
- Ipopt
- NLopt
- LbfgsB (not an official julia Pkg)
- Knitro (not an open source solver)
- Newtrunk  adjustment of trunk to use the Stopping Pkg
- test_ext_solvers: tests the provided wrappers to external solvers on the rosenbrock test function

src/compare_solvers.jl contains useful function to run batches of solvers on batches of problems. Both scripts run several solvers on a set of problems; each the set of solvers need not be distincts and a corresponding set of options is required, one option list per solver.  Both return two performance profiles and the corresponding stats dictionaries, one using function evaluations and the other CPU time.
- compare_solvers_with_options   The results are produced solver by solver.
- compare_solvers_with_options2  The results are produced problem by problem.


src/Ampl_JuMP contains some problems used for testing, both modeled in JuMP and AMPL
- bray and braxy: brachistochrone models
- msqrtals: an instance from the CUTEst collection translated both in JuMP and AMPL
- test script to validate that both models (AMPL and JuMP) are equivalent

src/tests contains several script helpful to compare solvers from any source. They should serve as examples.
- CUTEstUnc.list: list of unconstrained models in CUTEst
- testcompare: test the comparison tools.
- testgeneric:  template to test several solvers on several models (MPB, CUTEst, Ampl)
- AmplProblems.jl: script to load the Ampl test problems
- CUTEstProblems.jl: script to load the CUTEst test problems
- MPBProblems.jl: script to load the MPB test problems
