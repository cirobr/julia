using Pkg

# environment
Pkg.add("IJulia")
Pkg.add("CUDA")#; using CUDA

#ai/ml
Pkg.add("Flux")#; using Flux
Pkg.add("Images")#; using Images
Pkg.add("MLJ")#; using MLJ

# math
Pkg.add("LinearAlgebra")#; using LinearAlgebra
Pkg.add("Metrics")#; using Metrics
Pkg.add("Random")#; using Random
Pkg.add("StatsBase")#; using StatsBase
Pkg.add("Distributions")#; using Distributions

# charts
Pkg.add("Plots")#; using Plots
Pkg.add("StatsPlots")
Pkg.add("Printf")#; using Printf

# data
Pkg.add("CSV")#; using CSV
Pkg.add("DataFrames")#; using DataFrames
