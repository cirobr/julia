using Pkg

# environment
Pkg.add("IJulia")
Pkg.add("PyCall")
Pkg.add("CUDA")

#ai/ml
Pkg.add("Flux")
Pkg.add("MLJ")
Pkg.add("MLJFlux")
Pkg.add("MLDataUtils")
Pkg.add("MLDatasets")
Pkg.add("MLJLinearModels")
Pkg.add("MultivariateStats")
Pkg.add("ScikitLearn")
Pkg.add("GLM")

# math
Pkg.add("LinearAlgebra")
Pkg.add("Metrics")
Pkg.add("Random")
Pkg.add("StatsBase")
Pkg.add("Distributions")

# charts / images
Pkg.add("Plots")
Pkg.add("StatsPlots")
Pkg.add("Printf")

Pkg.add("Images")
Pkg.add("ImageView")
Pkg.add("VideoIO")
Pkg.add("GLMakie")

# data
Pkg.add("CSV")
Pkg.add("DataFrames")

#build
Pkg.build()