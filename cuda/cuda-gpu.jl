using CUDA
using Random
N = 10000

a_d = CuArray{Float32}(undef, (N, N))
b_d = CuArray{Float32}(undef, (N, N))

for i in 1:10
    randn!(a_d)
    randn!(b_d)

    c_d = a_d * b_d
end

global a_d = nothing
global b_d = nothing
global c_d = nothing
GC.gc()
