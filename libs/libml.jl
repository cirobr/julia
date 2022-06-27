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

    if numberOfEpochs <= 2
        println("Insufficient epochs")
    else
        p1 = Plots.plot(1:numberOfEpochs, epochLosses, size=(400,300), linewidth=2, legend=false, yaxis=:log,
                  title="Loss function")
        p2 = Plots.plot(2:numberOfEpochs, deltaLosses, size=(400,300), linewidth=2, legend=false, yaxis=:log,
                  title="Loss function derivative")
        p  = Plots.plot(p1, p2, layout = (1, 2), size=(900,300), legend=false)
        display(p)   # explicit "display", as variable "p" is local for the "if" statement
    end
end

function stopTrainingCriteria(lossVector::Vector{Float64}, minLoss::Float64)
    numberOfEpochs = size(lossVector)[1]

    # loss function below tolerance: stop
    if lossVector[end] <= minLoss   return(true)   end

    # loss function growing: stop
    if numberOfEpochs >= 3
        v = lossVector[end-2 : end]
        if issorted(v)   return(true)   end
    end

    return(false)
end