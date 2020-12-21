#%%
using CSV

using DataFrames
#%%
CSV.read("111",M1 ) => DataFrame
# M2 = CSV.File("lbfgsrcstP2.csv") |> DataFrame
# M3 = CSV.File("newtonP2.csv") |> DataFrame

#%%
#seleciona colunas
stats_uteis = stats[:, [:name, :nvar, :status, :elapsed_time, :iter]]

#%%
# filtra por status
res_lbfgs = stats_uteis[stats_uteis[:status] .== "first_order", :]

#%%
#ordena
naores_lbfgs = stats_uteis[stats_uteis[:status] .!= "first_order", :]
sort!(naores_lbfgs, :nvar, rev = true)

#%%
#contagens
conta_lbfgs = by(stats_uteis, :status, c -> DataFrame(count = nrow(c)))
