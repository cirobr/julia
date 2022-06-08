using DataStructures

function producer(N)
    for frame in 1:N
        enqueue!(imageBuffer, frame)
    end
end

function consumer()
    while true
        while isempty(imageBuffer)
            # println("buffer empty")
            continue
        end

        while !isempty(imageBuffer)
            frame = dequeue!(imageBuffer)
            println("read from buffer ...", frame)
            sleep(1/20)
        end
        #empty!(imageBuffer)
        println("end of buffer")
        break
    end
end

global imageBuffer = Queue{Int}()

# producer(100)
# consumer()

task_c = Threads.@spawn consumer()
task_p = Threads.@spawn producer(100)
