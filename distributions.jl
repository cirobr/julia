# include("./distributions.jl")

# using Pkg
using Distributions
using Plots
using Random

Random.seed!(123)

d = Normal(0, 1)
x = rand(d, 500)
histogram(x)

y = rand(Normal(0, 1), 500)
scatter(x, y)

gr()
x = 1:100; y = rand(100, 4)
plot(x, y, seriestype = :scatter, title = "My Scatter Plot")
