#%%
using CUTEst
using Projeto2Solvers
using NLPModels
using LinearAlgebra

#%%
# nlp = ADNLPModel(x -> (x[1] - 1)^2 + (x[2] - 2)^2 / 4, zeros(2))
nlp = CUTEstModel("ROSENBR")

#%%
output = uncsolver(nlp)

#%%
finalize(nlp)