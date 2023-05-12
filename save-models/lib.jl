using Flux
using JLD2

struct MyModel
    net
end

Flux.@functor MyModel


function savemodel(filename::String, model)

    MyModel()   = MyModel(model)
    modelcpu    = MyModel()
    model_state = Flux.state(modelcpu)
    jldsave(filename * ".jld2"; model_state)
end