using DataStructures

function producer(N)
    for frame in 1:N
        enqueue!(imageBuffer, frame)
    end
end

function consumer()
    while isempty(imageBuffer)
        continue
    end

    while !isempty(imageBuffer)
        frame = dequeue!(imageBuffer)
        println("data from buffer: ", frame)
        sleep(1/20)
    end
    empty!(imageBuffer)
    println("end of buffer")
    return
end

global imageBuffer = Queue{Int}()

task1 = Threads.@spawn consumer()
task2 = Threads.@spawn producer(100)
