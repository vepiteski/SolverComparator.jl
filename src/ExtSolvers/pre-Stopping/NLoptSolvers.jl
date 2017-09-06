NLoptSolvers = Function[]

fname=:LD_LBFGS
include("TemplateNLopt.jl")
#push!(NLoptSolvers,eval(fname))

fname=:LD_TNEWTON
include("TemplateNLopt.jl")
#push!(NLoptSolvers,eval(fname))

fname=:LD_TNEWTON_RESTART
include("TemplateNLopt.jl")
#push!(NLoptSolvers,eval(fname))

fname=:LD_TNEWTON_PRECOND_RESTART
include("TemplateNLopt.jl")
#push!(NLoptSolvers,eval(fname))

fname=:LD_TNEWTON_PRECOND
include("TemplateNLopt.jl")
#push!(NLoptSolvers,eval(fname))

fname=:LD_VAR1
include("TemplateNLopt.jl")
#push!(NLoptSolvers,eval(fname))

fname=:LD_VAR2
include("TemplateNLopt.jl")
#push!(NLoptSolvers,eval(fname))

