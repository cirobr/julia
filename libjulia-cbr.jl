# libraries
using StatsBase
using DataFrames
using MLDataUtils

using PyCall
rs  = pyimport("pyrealsense2")
cv2 = pyimport("cv2")            # video playback only


"""
image2Vector(M::Matrix)

Converts a matrix (image) in a vector.
"""
image2Vector(M::Matrix) = vec( Float32.(M) )   # 32-bits is faster on GPU



"""
batchImage2Vector(imagesArray3D)

Converts a 3D-array of matrices (images) in an array of vectors.
"""
function batchImage2Vector(imagesArray3D)
    h, v, N = size(imagesArray3D)
    vectorOfImageVectors = [ image2Vector( imagesArray3D[:, :, i] ) for i in 1:N]
end



"""
batchImage2Matrix(imagesArray3D)

Converts a 3D-array of matrices (images) in a matrix,
where each line is an observation (image), and each column is a predictor (pixel).
"""
function batchImage2Matrix(imagesArray3D)
    vectorOfImageVectors = batchImage2Vector(imagesArray3D)
    M = reduce(hcat, vectorOfImageVectors)
    M'
end



"""
batchImage2DF(imagesArray3D)

Converts a 3D-array of matrices (images) in a dataframe,
where each line is an observation (image), and each column is a predictor (pixel).
"""
function batchImage2DF(imagesArray3D)
    M = batchImage2Matrix(imagesArray3D)
    DataFrame(M, :auto)
end




"""
vector2Image(vec, h, v)

Converts a vector "vec" in a matrix of "h" lines by "v" columns.
"""
vector2Image(vec, h, v) = reshape(Float32.(vec), (h, v))


"""
Centers and Rescales predictors on input matrix by columns.
"""
function rescaleByColumns(X::Matrix)
    # using StatsBase
    X = Float32.(X)
    dt = StatsBase.fit(ZScoreTransform, X; dims=1, center=true, scale=true)
    rescaledX = StatsBase.transform(dt, X)
end



"""
Centers and Rescales predictors on input matrix by rows.
"""
function rescaleByRows(X::Matrix)
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



"""
hex2RGB(img)

Converts images from hex-3D-array to RGB-2D-matrix representation.
"""
function hex2RGB(img)
    img2 = Float32.(img) ./ Float32(255.0)
    img2 = RGB.(img2[:,:,1], img2[:,:,2], img2[:,:,3])
end



"""
hex2uint8(img)

Converts images from hex to uint8 representation.
"""
function hex2uint8(img)
    img2 = img_HWC(img)
    img2 = reinterpret(UInt8, img2) .|> UInt8    
end



"""
cv2ShowImage(imageFullPath, windowName)

Uses OpenCV to show a single image on a window.
"""
function cv2ShowImage(imageFullPath, windowName)
    img = cv2.imread(imageFullPath)
    cv2.imshow(windowName, img)
    cv2.waitKey(Int32(0))
    cv2.destroyWindow(windowName)
end



"""
cv2PlayImageBuffer(imageBuffer, windowName, framesPerSecond)

Uses OpenCV to play a sequence of images in a buffer as video on a window.
"""
function cv2PlayImageBuffer(imageBuffer, windowName, framesPerSecond)
    frameInterval_ms = trunc( Int16, Float32(1.0 / framesPerSecond * 1000.0) )

    for img in imageBuffer
        cv2.imshow(windowName, img)
        cv2.waitKey(frameInterval_ms)
    end
    cv2.destroyWindow(windowName);
end
