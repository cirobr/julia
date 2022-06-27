using Flux
using MLJ
# using Plots

function printMetrics(ŷ, y)
    display(MLJ.confmat(ŷ, y))
    println("accuracy: ", round(MLJ.accuracy(ŷ, y); digits=3))
    println("f1-score: ", round(MLJ.multiclass_f1score(ŷ, y); digits=3))
end

# custom made function that provides access to loss function outcome
function trainModel!(loss, ps, data, opt)
    lossVector = Vector{Float32}()
        
    for d in data
        l = loss(d...)
        gs = Flux.gradient(ps) do
            loss(d...)
        end
        Flux.update!(opt, ps, gs)
            
        push!(lossVector, l)
    end
    
    return mean(lossVector)
end

function stopTrainingCriteria(lossVector::Vector{Float64}, minLoss::Float64, nearZero::Float64)
    numberOfEpochs = size(lossVector)[1]

    # loss function below minimum: stop
    if lossVector[end] <= minLoss
        println("loss function below minimum")
        return(true)
    end

    if numberOfEpochs >= 3
        # loss function with small variation: stop
        if abs(lossVector[end-1] - lossVector[end]) <= nearZero
            println("loss function with small variation")
            return(true)
        end

        # loss function growing: stop
        if issorted( lossVector[end-2 : end] )
            println("loss function growing")
            return(true)
        end
    end

    return(false)
end