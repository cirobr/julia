# https://docs.julialang.org/en/v1/manual/multi-threading/

println("Available threads = ", Threads.nthreads() )              # number of available threads
a = zeros(10)

global s = 0
lk = ReentrantLock()

Threads.@threads for i = 1:10     # each loop is a different thread
    a[i] = Threads.threadid()     # each vector element receives a thread ID
    # global s += a[i]            # variable "s" needs memory protection

    begin                         # protection applied to global variable "s"
        lock(lk)
        try
            global s += a[i]
        finally
            unlock(lk)
        end
    end
end

#println(a')
#println(s)
println("Equal sum: ", s == sum(a))