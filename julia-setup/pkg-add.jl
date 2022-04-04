using Pkg

# environment
Pkg.add("IJulia")
Pkg.add("PyCall")

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

# charts
Pkg.add("Plots")
Pkg.add("StatsPlots")
Pkg.add("Printf")

# media
Pkg.add("Images")
Pkg.add("ImageView")
Pkg.add("ImageTransformations")
Pkg.add("ImageDraw")
Pkg.add("OpenCV")

# hpc
Pkg.add("CUDA")
Pkg.add("Distributed")
Pkg.add("FLoops")

# data
Pkg.add("CSV")
Pkg.add("DataFrames")
Pkg.add("DataStructures")   # stacks, queues, ...
Pkg.add("FileIO")
Pkg.add("ImageIO")
#Pkg.add("VideoIO"); Pkg.add("GLMakie")

#build
Pkg.update()
Pkg.build()