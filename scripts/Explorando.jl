#%%
using CSV
using DataFrames
#%%
# df = DataFrame()
#%%

statsncb = CSV.File("ncb-1000.csv") |> DataFrame
statslst = CSV.File("lst-1000.csv") |> DataFrame
statslbf = CSV.File("lbfgs-1000.csv") |> DataFrame

#%%
#seleciona colunas
statsncb_uteis = statsncb[:, [:name, :nvar, :status, :elapsed_time, :iter]]
statslst_uteis = statslst[:, [:name, :nvar, :status, :elapsed_time, :iter]]
statslbf_uteis = statslbf[:, [:name, :nvar, :status, :elapsed_time, :iter]]

#%%
# filtra por status
res1 = statsncb_uteis[statsncb_uteis[:status] .== "first_order", :]
res2 = statslst_uteis[statslst_uteis[:status] .== "first_order", :]
res3 = statslbf_uteis[statslbf_uteis[:status] .== "first_order", :]
#%%

#%%
#ordena
naores1 = statsncb_uteis[statsncb_uteis[:status] .!= "first_order", :]
sort!(naores1, [:nvar, :name], rev = [true, false])
println(naores1)
#%%
naores2 = statslst_uteis[statslst_uteis[:status] .!= "first_order", :]
sort!(naores2, [:nvar, :name], rev = [true, false])
println(naores2)
#%%
naores3 = statslbf_uteis[statslbf_uteis[:status] .!= "first_order", :]
sort!(naores3, [:nvar, :name], rev = [true, false])
println(naores3)
#%%
# CSV.write("naoncb-5.csv", naores1)
# CSV.write("naolst-5.csv", naores2)
# CSV.write("naolbfgs-5.csv", naores3)
#%%

#%%
#contagens
conta_1 = by(statsncb_uteis, :status, c -> DataFrame(count = nrow(c)))
print(conta_1)
#%%
conta_2 = by(statslst_uteis, :status, c -> DataFrame(count = nrow(c)))
print(conta_2)
#%%
conta_3 = by(statslbf_uteis, :status, c -> DataFrame(count = nrow(c)))
print(conta_3)
#%%
using Latexify
print(latexify(naores2, env = :table, latex = false))
#%%
A1 = naores1[:,:name]
A2 = naores2[:,:name]
A3 = naores3[:,:name]

m=1
n=1
for i in A3
    verifica = :false
    for j in A2
        if i == j
            verifica = :true
            for k in A1
                if i == k
                    println("$i não resolvido por nenhum dos 3")
                end
            end        
        end
    end
    if verifica == :false
        for j in A1
            if i == j
                println("Não por A1, nem por A3: $m:- $i")
                m +=1
                verifica = :true
            end
        end
    end
    if verifica == :false
        #não resolveu A1
        println("##  APENAS: Não por A3:$n- $i")
        n+=1
    end
end
#%%
m=1
n=1
for i in A1, j in A2 
    verifica = :false
    for k in A3
        if i == k || j == k
            println("$i não resolvido por nenhum dos 3")
        end
    end
end