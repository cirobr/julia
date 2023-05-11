# using Pkg
# env = expanduser("~/julia-envs/dev-env")
# Pkg.activate(env)

using .BSON
using .Flux
println("libraries OK")

model = Dense(5,5)
BSON.@load "mymodel.bson" modelcpu
modelcpu
println("model loaded")