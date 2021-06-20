using PyCall
np = pyimport("numpy")
a = np.ones(100)
s = np.sum(a)
println(s)