NLoptSolvers = Function[]

fname=:LD_LBFGS
include("TemplateNLoptS.jl")
#push!(NLoptSolvers,eval(fname))

fname=:LD_TNEWTON
include("TemplateNLoptS.jl")
#push!(NLoptSolvers,eval(fname))

fname=:LD_TNEWTON_RESTART
include("TemplateNLoptS.jl")
#push!(NLoptSolvers,eval(fname))

fname=:LD_TNEWTON_PRECOND_RESTART
include("TemplateNLoptS.jl")
#push!(NLoptSolvers,eval(fname))

fname=:LD_TNEWTON_PRECOND
include("TemplateNLoptS.jl")
#push!(NLoptSolvers,eval(fname))

fname=:LD_VAR1
include("TemplateNLoptS.jl")
#push!(NLoptSolvers,eval(fname))

fname=:LD_VAR2
include("TemplateNLoptS.jl")
#push!(NLoptSolvers,eval(fname))

