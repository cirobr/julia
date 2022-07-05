using DataStructures

function producer(N)
    Threads.@spawn for frame in 1:N
        enqueue!(imageBuffer, frame)
    end
end

function consumer()
    global keepchecking = true

    while keepchecking
        while isempty(imageBuffer)   sleep(0.001)   end   # sleep reduces overhead for monitoring

        while !isempty(imageBuffer)
            frame = dequeue!(imageBuffer)
            println("read from buffer ...", frame)
            sleep(1/15)
        end
        println("end of buffer")
    end
    println("end of loop")
end

function kill_consumer()
    global keepchecking = false
end

Threads.nthreads()

global imageBuffer = Queue{Int}()
task_c = Threads.@spawn consumer()
task_p = Threads.@spawn producer(10)

# kill_consumer()

display( (istaskstarted(task_c), istaskfailed(task_c), istaskdone(task_c)) )
