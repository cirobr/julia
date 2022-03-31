#using CUDA
using Random
N = 5000                            # 20s on wsl
a = Array{Float32}(undef, (N, N))
b = Array{Float32}(undef, (N, N))
c = Array{Float32}(undef, (N, N))

@time for i in 1:10
    randn!(a)                       #a = randn(N, N)
    randn!(b)
    global c = a * b
end

# cleanup memory
global a = nothing
global b = nothing
global c = nothing
GC.gc()