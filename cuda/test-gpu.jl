# libraries
using CUDA

using Flux             # the julia ml library
using Images           # image processing and machine vision for julia
using MLJ              # make_blobs, rmse, confmat, categorical
using MLDataUtils      # label, nlabel, labelfreq
using MLDatasets       # mnist

using MLJLinearModels

using LinearAlgebra    # pinv pseudo-inverse matrix
using Metrics          # r2-score
using Random
using StatsBase        # standardize (normalization)
using Distributions

using Plots; gr()
using StatsPlots
using Printf

using CSV
using DataFrames

# load mnist from MLDatasets
trainX_original,      trainY_original      = MNIST.traindata()
validationX_original, validationY_original = MNIST.testdata();

#display([MNIST.convert2image(MNIST.traintensor(i)) for i in 1:5])
trainY_original[1:5]'

# trainset, testset, validation set
Random.seed!(1)
(trainX, trainY), (testX, testY) = stratifiedobs((trainX_original, trainY_original), p = 0.7)
validationX = copy(validationX_original); validationY = copy(validationY_original)

size(trainX), size(testX), size(validationX)

# functions for feature extraction
meanIntensity(img) = mean(Float64.(img))

function hSymmetry(img)
    imgFloat = Float64.(img)
    imgReverse = reverse(imgFloat, dims=1)
    return -mean( abs.(imgFloat - imgReverse) )
end

h, v, N = size(trainX)
a = [meanIntensity( trainX[:, :, i] ) for i in 1:N]
b = [hSymmetry( trainX[:, :, i] )     for i in 1:N]
trainX = hcat(a, b)
display(size(trainX))

# rescale predictors
function rescaleByColumns(X)
    # using StatsBase
    X = Float32.(X)
    dt = StatsBase.fit(ZScoreTransform, X; dims=1, center=true, scale=true)
    rescaledX = StatsBase.transform(dt, X)
end

trainX = rescaleByColumns(trainX)
mean(trainX, dims=1)


# # select two classes
# P = 5   # positive class
# N = 1   # negative class

# # data selection from above classes and sizes
# trainX = vcat( trainX[trainY .== P, :], trainX[trainY .== N, :] )
# trainY = vcat( trainY[trainY .== P],    trainY[trainY .== N] )
# levels(trainY)


# specific conversions for MLJ
trainX = DataFrame(trainX, :auto)
trainY = categorical(trainY, ordered=true);

# copy to GPU
sx = size(trainX)
tx = CuArray{Float32}(undef, sx)
tx = copy(trainX)

sy = size(trainY)
ty = CuArray{Int32}(undef, sy)
ty = copy(trainY);

#@load LogisticClassifier pkg=MLJLinearModels
mdl = LogisticClassifier()
@time mach = machine(mdl, tx, ty)
@time fit!(mach)

params = fitted_params(mach)
p = MLJ.predict(mach, trainX)
p[1:5]