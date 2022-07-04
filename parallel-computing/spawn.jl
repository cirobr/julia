x=1

Threads.@spawn begin
    while x == 1
    end
    println("done!")
end

x=0