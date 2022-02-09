# libraries
using StatsBase
using DataFrames
using MLDataUtils



image2Vector(M) = vec(Float64.(M))



function batchImage2Vector(imagesArray3D)
    h, v, N = size(imagesArray3D)
    vectorOfImageVectors = [ image2Vector( imagesArray3D[:, :, i] ) for i in 1:N]
end



function batchImage2Matrix(imagesArray3D)
    vectorOfImageVectors = batchImage2Vector(imagesArray3D)
    M = reduce(hcat, vectorOfImageVectors)
    M'
end



function batchImage2DF(imagesArray3D)
    vectorOfImageVectors = batchImage2Vector(imagesArray3D)
    M = reduce(hcat, vectorOfImageVectors)
    DataFrame(M', :auto)
end



vector2Image(vec, h, v) = reshape(Float64.(vec), (h, v))



function rescaleByColumns(X)
    # using StatsBase
    X = Float64.(X)
    dt = StatsBase.fit(ZScoreTransform, X; dims=1, center=true, scale=true)
    rescaledX = StatsBase.transform(dt, X)
end



function rescaleByRows(X)
    # using StatsBase
    X = Float64.(X)
    dt = StatsBase.fit(ZScoreTransform, X; dims=2, center=true, scale=true)
    rescaledX = StatsBase.transform(dt, X)
end



function shuffleRowMatrix(X, Y)
    ndim = size(Y)[1]
    ind = randperm(ndim)   # shuffle array indices
    shuffledX = X[ind, :]
    shuffledY = Y[ind]
    
    return (shuffledX, shuffledY)
end



