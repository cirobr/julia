# https://docs.julialang.org/en/v1/stdlib/Distributed/
# julia -p 3 distrib.jl   # three workers

using Distributed
println("Available processes = ", Distributed.nprocs() )

# configure workers. must be done before any @everywhere macro
if nprocs() != 4
    rmprocs( workers() )   # remove all workers, keep only the main process
    addprocs(3)            # add n worker processes
    println("Updated processes = ", Distributed.nprocs() )
end

# create data
N, d = (10000000, 12)
X = Array{Any}(undef, d)
Y = Array{Float32}(undef, d)

for i in 1:d
    X[i] = [ rand(0:9) for i in 1:N ]
end

# kernel of distributed function
@everywhere distKernel(V) = Float32.( sum(V) )   #@everywhere makes kernel available to all processes

# distributed calculus
Y = pmap(distKernel, X)
println(Y')