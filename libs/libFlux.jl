using Flux

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