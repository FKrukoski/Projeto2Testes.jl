using CUTEst
using JSOSolvers
using Projeto2Solvers
using LinearAlgebra
using NLPModels
using Plots
using SolverBenchmark
using JuMP
using Ipopt

#%%
function runcutest()
  
  #pnames = CUTEst.select(max_var=2, max_con=0, only_free_var=true)
  # pnames = CUTEst.select(max_var=5, max_con=0, only_free_var=true)

  pnames = CUTEst.select(min_var=1, max_var = 1000,
                          max_con=0, only_free_var=true)
  
  # pnames = CUTEst.select(min_var=501, max_var = 1000,
  #                         max_con=0, only_free_var=true)
                          

  sort!(pnames)
  problems = (CUTEstModel(p) for p in pnames) # Generator of problems

  # If you need to define different arguments, you can wrap
  trunk_wrapper(nlp; kwargs...) = trunk(nlp, max_time=10.0; kwargs...)
  my_newton_wrapper(nlp; kwargs...) = newton(nlp, max_time=10.0; kwargs...)
  my_gradiente_wrapper(nlp; kwargs...) = gradiente(nlp, max_time=10.0; kwargs...)

  solvers = Dict(
    :lbfgs => lbfgs,
    # :trunk => trunk_wrapper,
    # :bfsg_bl => bfgs_bl,
    # :newton => my_newton_wrapper,
    :newcombusca => newtoncombusca,
    #:bfgs_rc => bfgs_rc,
    :l_bfgs_rcst => l_bfgs_rcst
    # :gradiente => my_gradiente_wrapper
    
    )

  stats = bmark_solvers(solvers, problems)
end

#%%
function table_and_plots(stats)
  cols = [:name, :nvar, :status, :objective, :dual_feas, :elapsed_time, :neval_obj, :neval_grad, :neval_hess]
  for (k,v) in stats
    open("tabelas/tabela-$k.md", "w") do io
      pretty_stats(io, v[:,cols])
    end
    open("tabelas/tabela-$k.tex", "w") do io
      pretty_latex_stats(io, v[:,cols])
    end
  end

  # Performance profile

  # First, define metrics
  not_first_order(df) = df.status .!= :first_order
  Fx = hcat([df.objective for df in values(stats)]...)
  Fx[isnan.(Fx)] .= Inf
  fmin = minimum(Fx, dims=2)
  not_best_fx(df) = df.dual_feas .> fmin * 1.01 .+ 1e-6 # 1% tolerance, with safeguard for 0.
  costs = [
    df -> df.elapsed_time,
    df -> not_first_order(df) * Inf + df.elapsed_time,
    df -> not_best_fx(df) * Inf + df.elapsed_time,
    df -> not_first_order(df) * Inf + df.neval_obj + df.neval_grad + df.neval_hess + df.neval_hprod
  ]
  costnames = [
    "Pure Δt",
    "Δt checking 1st order",
    "Δt checking fx ≈ fmin",
    "Eval checking 1st order"
  ]
  p = profile_solvers(stats, costs, costnames)
  png(p, "plots/profile")
end

#%%
# You can comment out this after the tests are run
stats = runcutest()
p = table_and_plots(stats)

#%%
# Salvar resultados em data frame - MUDAR OS NOMES
CSV.write("todos-2.csv", stats)
CSV.write("ncb-2.csv", stats[:newcombusca])
CSV.write("lst-2.csv", stats[:l_bfgs_rcst])
CSV.write("lbfgs-2.csv", stats[:lbfgs])
