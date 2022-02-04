#using CUDA
using Random
N = 10000

#a_d = CuArray{Float32}(undef, (N, N))
#b_d = CuArray{Float32}(undef, (N, N))
#c_d = CuArray{Float32}(undef, (N, N))

for i in 1:10
    a = randn(N, N)
    b = randn(N, N)

    c = a * b
end

#global a_d = nothing
#global b_d = nothing
#global c_d = nothing
#GC.gc()
