using CUDA
using Flux
using Random

N = 10
a_d = rand(N, N)

b_d = CuArray{Float32}(undef, (N, N))
rand!(b_d)

c_d = rand(N, N) |> gpu