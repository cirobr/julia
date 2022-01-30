using CUDA
using Random
N = 10000

a = CuArray{Float32}(undef, (N, N))
b = CuArray{Float32}(undef, (N, N))
c = CuArray{Float32}(undef, (N, N))

a = randn(N, N)
b = randn(N, N)

c = a * b
d = copy(c)
println(d[1,1])

a = nothing
b = nothing
c = nothing
GC.gc()
