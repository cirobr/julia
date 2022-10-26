n_threads = 4

mutable struct Param
    pipe::Int32
    cfg::Float32
end

arrayOfThreads = Vector{Param}(undef, n_threads)
arrayOfThreads[1] = Param( rand(1:10), rand() )
arrayOfThreads
arrayOfThreads[1].pipe = 45
arrayOfThreads