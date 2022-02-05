#using CUDA
using Random
N = 10000

for i in 1:10
    a = randn(N, N)
    b = randn(N, N)

    c = a * b
end
