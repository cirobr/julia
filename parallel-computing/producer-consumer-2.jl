using DataStructures

function producer(N)
    for frame in 1:N
        begin
            lock(lk)
            try
                enqueue!(imageBuffer, frame)
            finally
                unlock
            end
        end
        
    end
end

function consumer()
    while isempty(imageBuffer)
        continue
    end

    frame=[]
    while !isempty(imageBuffer)
        begin
            lock(lk)
            try
                frame = dequeue!(imageBuffer)
            finally
                unlock
            end
        end
        println("data from buffer: ", frame)
        sleep(1/20)
    end
    empty!(imageBuffer)
    println("end of buffer")
    return
end

global imageBuffer = Queue{Int}()
lk = ReentrantLock()
producer(100)
consumer()
