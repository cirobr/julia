using DataStructures

function producer(N)
    for frame in 1:N
        enqueue!(imageBuffer, frame)
    end
end

function consumer()
    breakloop = false

    while !breakloop
        while isempty(imageBuffer)   continue   end

        while !isempty(imageBuffer)
            frame = dequeue!(imageBuffer)
            println("read from buffer ...", frame)

            if frame == -1   breakloop = true   end
            sleep(1/20)
        end
        println("end of buffer")
    end
    println("end of loop")
end

function kill_thread()
    enqueue!(imageBuffer, -1)
end

Threads.nthreads()

global imageBuffer = Queue{Int}()
task_c = Threads.@spawn consumer()
task_p = Threads.@spawn producer(10)

kill_thread()