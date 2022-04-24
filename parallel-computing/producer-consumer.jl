using DataStructures

function producer(N)
    for frame in 1:N
        enqueue!(imageBuffer, frame)
    end
end

function consumer()
    while true
        while isempty(imageBuffer)
            continue
        end

        while !isempty(imageBuffer)
            frame = dequeue!(imageBuffer)
            println("out of buffer ...", frame)
            sleep(1/20)
        end
        #empty!(imageBuffer)
        println("end of buffer")
    end
end

global imageBuffer = Queue{Int}()

# producer(100)
# consumer()

task1 = Threads.@spawn consumer()
task2 = Threads.@spawn producer(100)
