using DataStructures

N = 5000
frameset = [1:N;]
frameset[1:10]'

bufferSize = 20
cb = CircularBuffer{Int}(bufferSize)   # allocate an Int buffer with maximum capacity n
empty!(cb)                             # reset the buffer

function producer(cb, frame)
    if !isfull(cb)   push!(cb, frame)   end
end


function consumer(cb)
    while !isempty(cb)
        popfirst!(cb)      
    end
end

for frame in frameset   producer(cb, frame)   end
display(cb')

popfirst!(cb)
cb'

consumer(cb)
cb'
