# libraries
using CUDA
using Random
CUDA.versioninfo()

# allocate arrays on GPU
N = 5000                                 # 5s on wsl
a_d = CuArray{Float32}(undef, (N, N))
b_d = CuArray{Float32}(undef, (N, N))
c_d = CuArray{Float32}(undef, (N, N))

@time for i in 1:10
    randn!(a_d)                          # populate arrays
    randn!(b_d)
    global c_d = a_d * b_d               # calculate on GPU and store result on GPU
end

# cleanup memory
global a_d = nothing
global b_d = nothing
global c_d = nothing
GC.gc()
