module myapp

using Random

function julia_main()::Cint
    x=rand(10)
    display(x)
    return 0
end

end # module
