using Pkg

# environment
Pkg.add("IJulia")
Pkg.add("CUDA")

#ai/ml
Pkg.add("Flux")
Pkg.add("Images")
Pkg.add("MLJ")

# math
Pkg.add("LinearAlgebra")
Pkg.add("Metrics")
Pkg.add("Random")
Pkg.add("StatsBase")
Pkg.add("Distributions")

# charts
Pkg.add("Plots")
Pkg.add("StatsPlots")
Pkg.add("Printf")

# data
Pkg.add("CSV")
Pkg.add("DataFrames")

#build
Pkg.build()