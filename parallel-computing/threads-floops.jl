# https://github.com/JuliaFolds/FLoops.jl
# $ julia --threads 4            (takes precedence)
# $ export JULIA_NUM_THREADS=4

using FLoops

println( "Available threads = ", Threads.nthreads() )
N = 100
a = zeros(N)

s = 0

@floop for i = 1:N                # each loop is a different thread
    a[i] = Threads.threadid()     # each vector element receives a thread ID
    # global s += a[i]            # variable "s" needs memory protection
    @reduce s += a[i]             # "s" is protected
end

println(a')
#println(s)
println("Equal sum: ", s == sum(a))