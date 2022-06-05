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

function plotTrainingEvolution(epochLosses::Vector{Float64}, deltaLosses::Vector{Float64})
    epochs = size(epochLosses)[1]

    if epochs > 2
        p1 = plot(1:epochs, epochLosses, size=(400,300), linewidth=2, legend=false, yaxis=:log,
                  title="Loss function")
        p2 = plot(2:epochs, deltaLosses, size=(400,300), linewidth=2, legend=false, yaxis=:log,
                  title="Loss function derivative")
        p  = plot(p1, p2, layout = (1, 2), size=(900,300), legend=false); display(p)
    end
end

function stopTrainingCriteria(epochLosses::Vector{Float64}, deltaLosses::Vector{Float64}, minDeltaLoss::Float64)
    epoch = size(epochLosses)[1]

    # too few epochs: continue
    if epoch == 1   return(false)   end

    # loss derivative reaching minimum: stop
    if epoch > 1
        if deltaLosses[end] < minDeltaLoss   return(true)   end
    end

    # loss derivative growing: stop
    if epoch > 2
        if issorted(deltaLosses[end-2 : end])   return(true)   end
    end

    return(false)
end