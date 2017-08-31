function intermediate(
  alg_mod::Int,
  iter_count::Int,
  obj_value::Float64,
  inf_pr::Float64, inf_du::Float64,
  mu::Float64, d_norm::Float64,
  regularization_size::Float64,
  alpha_du::Float64, alpha_pr::Float64,
  ls_trials::Int)
  # ...
  return true  # Keep going
end


function Ipopt_NMPBS(nlp :: AbstractNLPModel;
                     stp :: TStopping = TStopping(),
                     verbose :: Bool = true
                     )                
    
    IpoptModel = NLPtoMPB(nlp, 
                          IpoptSolver(print_level = 0,
                                      max_iter = stp.max_iter,
                                      tol = stp.rtol,
                                      max_cpu_time = stp.max_time)
                          );
    
    x0 = nlp.meta.x0
    g0 = grad(nlp,x0)
    norm_g0 = norm(g0,Inf)
    ret = MathProgBase.optimize!(IpoptModel)
    
    minx = IpoptModel.inner.x
    
    minf = obj(nlp,minx)
    ming = grad(nlp,minx)
    gnorm2 = norm(ming)
    norm_g = norm(ming,Inf)
    
    iter = nlp.counters.neval_obj
    
    #optimal = (norm_g < ϵ) || (isinf(minf) & (minf<0.0))
    optimal, unbounded, tired, elapsed_time = stop(nlp,stp,iter,minx,minf,ming)

    if optimal status = :Optimal
    else status = ret
    end
    return (minx, minf, gnorm2, iter, optimal, ret == :MAXEVAL_REACHED, status)
end

