using Pkg
Pkg.update()

# create environment
foldername = expanduser("~/dev-jl/")
mkdir(foldername)
cd(foldername)
Pkg.activate(".")

# add packages
Pkg.add("IJulia")                           # Jupyter i/f
Pkg.add("PkgTemplates")

# private packages
# https://github.com/GunnarFarneback/LocalRegistry.jl/blob/master/docs/ssh_keys.md
Pkg.add(url="git@github.com:cirobr/PreprocessingImages.jl.git")
Pkg.add(url="git@github.com:cirobr/UNetFlux.jl.git")

#ai/ml
Pkg.add("Flux")
Pkg.add("MLJ")
Pkg.add("MLJFlux")
Pkg.add("MLUtils")
Pkg.add("MLDatasets")   # mnist
Pkg.add("MLJLinearModels")
Pkg.add("MultivariateStats")
Pkg.add("MLJMultivariateStatsInterface")
# Pkg.add("ScikitLearn")
Pkg.add("MLJScikitLearnInterface")
Pkg.add("GLM")
# Pkg.add("ObjectDetector")   # yolo

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
Pkg.add("Colors")
Pkg.add("Images")
# Pkg.add("ImageView")
Pkg.add("ImageTransformations")
Pkg.add("ImageDraw")
# Pkg.add("OpenCV")
# Pkg.add("GLMakie")
Pkg.add("VideoIO")
# Pkg.add("PerceptualColourMaps")   # depends on python matplotlib

# hpc
Pkg.add("Distributed")
Pkg.add("FLoops")

# data
Pkg.add("CSV")
Pkg.add("DataFrames")
Pkg.add("DataStructures")   # stacks, queues, ...
Pkg.add("FileIO")
Pkg.add("ImageIO")
Pkg.add("ArgParse")
Pkg.add("BSON")
Pkg.add("JLD")

# tools
Pkg.add("PyCall")
Pkg.add("BenchmarkTools")
Pkg.add("CUDA")
using CUDA; CUDA.versioninfo()   # skip if no gpu

#build
Pkg.update()
Pkg.build()