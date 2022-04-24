using CUDA

a = Array{Int32}(undef, 5)
b = Vector{Float64}[]
b_d = CuArray{Float32}(undef, (2, 2))

x = Array{Int32}(undef, 0)
typeof( Int32[] ) == typeof( Vector{Int32}(undef, 0) )