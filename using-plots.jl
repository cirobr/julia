using Plots
x = 1:10
f(x) = x^2 - 7x
y = f.(x)

gr()                                # use the GR backend
plot(x, y, label="line")            # plot a line
scatter!(x, y, label="points")      # mutate previous plot (!) and add points at same chart
