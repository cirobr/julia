using Flux
using MLJ

function printMetrics(ŷ, y)
    display(MLJ.confmat(ŷ, y))
    println("accuracy: ", round(MLJ.accuracy(ŷ, y); digits=3))
    println("f1-score: ", round(MLJ.multiclass_f1score(ŷ, y); digits=3))
end

# custom made function that provides access to loss function outcome
function trainModel!(loss, ps, data, opt)
    dataLosses = Vector{Float32}()
        
    for d in data
        l = loss(d...)
        gs = gradient(ps) do
            loss(d...)
        end
        Flux.update!(opt, ps, gs)
            
        push!(dataLosses, l)
    end
    
    return mean(dataLosses)
end