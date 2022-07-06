# https://docs.julialang.org/en/v1/manual/multi-threading/
# $ julia --threads 4            (takes precedence)
# $ export JULIA_NUM_THREADS=4

println( "Available threads = ", Threads.nthreads() )
N = 100
a = zeros(N)

global s = 0
lk = ReentrantLock()

Threads.@threads for i = 1:size(a)[1]   # each loop is a different thread
    a[i] = Threads.threadid()           # each element vector receives a thread ID
    # global s += a[i]                  # variable "s" needs memory protection

    begin                               # protection applied to global variable "s"
        lock(lk)
        try
            global s += a[i]
        finally
            unlock(lk)
        end
    end
end

println(a')
# println(s)
println("Equal sum: ", s == sum(a))