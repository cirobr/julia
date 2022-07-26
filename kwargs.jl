function f(a, b; c=0, d=1)
    println(a, b)
    println(c, d)
end

f(1, 1; d=4)