using Flux
using MLJ
using Plots

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
        gs = Flux.gradient(ps) do
            loss(d...)
        end
        Flux.update!(opt, ps, gs)
            
        push!(dataLosses, l)
    end
    
    return mean(dataLosses)
end

function plotTrainingEvolution(epochLosses::Vector{Float64}, deltaLosses::Vector{Float64})
    numberOfEpochs = size(epochLosses)[1]

    if numberOfEpochs > 2
        p1 = Plots.plot(1:numberOfEpochs, epochLosses, size=(400,300), linewidth=2, legend=false, yaxis=:log,
                  title="Loss function")
        p2 = Plots.plot(2:numberOfEpochs, deltaLosses, size=(400,300), linewidth=2, legend=false, yaxis=:log,
                  title="Loss function derivative")
        p  = Plots.plot(p1, p2, layout = (1, 2), size=(900,300), legend=false)
        display(p)   # explicit "display", as variable "p" is local for the "if" statement
    end
end

function stopTrainingCriteria(epochLosses::Vector{Float64}, deltaLosses::Vector{Float64}, minDeltaLoss::Float64)
    numberOfEpochs = size(epochLosses)[1]
    numberOfLosses = numberOfEpochs - 1

    # too few epochs: continue
    if numberOfEpochs == 1   return(false)   end

    # loss derivative reaching minimum: stop
    if numberOfEpochs > 1
        if deltaLosses[end] < minDeltaLoss   return(true)   end
    end

    # loss derivative growing: stop
    if numberOfLosses >= 3
        if issorted(deltaLosses[end-2 : end])   return(true)   end
    end

    return(false)
end