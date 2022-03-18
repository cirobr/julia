# libraries
using StatsBase
using DataFrames
using MLDataUtils



image2Vector(M) = vec( Float32.(M) )   # 32-bits is faster on GPU



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
    M = batchImage2Matrix(imagesArray3D)
    DataFrame(M, :auto)
end




vector2Image(vec, h, v) = reshape(Float32.(vec), (h, v))



function rescaleByColumns(X)
    # using StatsBase
    X = Float32.(X)
    dt = StatsBase.fit(ZScoreTransform, X; dims=1, center=true, scale=true)
    rescaledX = StatsBase.transform(dt, X)
end



function rescaleByRows(X)
    # using StatsBase
    X = Float32.(X)
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



function filesWithinFolder(folder, prefix, ext)
    cutoffName = length(prefix) + 1
    files = readdir(folder)
    extFiles = [file for file in files if occursin( ext, file )]
    sortedExtFiles = sort( [ parse(Int, file[cutoffName : end-4])  for file in extFiles ] )
    sortedExtFiles = string.(folder, "/", prefix, sortedExtFiles, ext)
end



img_CHW(img) = Images.channelview(img)
img_HWC(img) = Images.permutedims(img_CHW(img), (2, 3, 1))
img_CWH(img) = Images.permutedims(img_CHW(img), (1, 3, 2))



function hex2RGB(img)
    img2 = Float32.(img) ./ Float32(255.0)
    img2 = RGB.(img2[:,:,1], img2[:,:,2], img2[:,:,3])
end



function hex2uint8(img)
    img2 = img_HWC(img)
    img2 = reinterpret(UInt8, img2) .|> UInt8    
end



