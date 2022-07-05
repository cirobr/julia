Threads.nthreads(), Threads.threadid()

global imageBuffer = []

producer(N) = [1:N;]                 # create kernel function

N = 200
task1 = Threads.@spawn producer(N)   # assign kernel function to a variable task and execute in a thread

imageBuffer = Threads.fetch(task1)   # fetch kernel result from variable task
imageBuffer'
