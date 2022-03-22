using DataStructures

function producer(N)
    for i in 1:N
        enqueue!(imageBuffer, i)
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
    println("end of buffer")
    return
end

global imageBuffer = Queue{Int}()

task1 = Threads.@spawn consumer()
task2 = Threads.@spawn producer(100)
