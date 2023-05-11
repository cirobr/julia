# using Pkg
# env = expanduser("~/julia-envs/dev-env")
# Pkg.activate(env)

using .BSON
using .Flux
println("libraries OK")

modelcpu = Dense(5,5)
BSON.@save "mymodel.bson" modelcpu
println("model saved")