# support library to ease image manipulation
module libImg



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

Converts a vector "vec" in a matrix of "h" rows by "v" columns.
"""
vector2Image(vec, h, v) = reshape(Float32.(vec), (h, v))


rgb2CHW(img) = Images.channelview(img)
rgb2HWC(img) = Images.permutedims(rgb2CHW(img), (2, 3, 1))
rgb2CWH(img) = Images.permutedims(rgb2CHW(img), (1, 3, 2))



"""
rgb2opencv(img)

Converts images from RGB-2D to OpenCV type of representation.
"""
function rgb2opencv(img)
    img2 = rgb2CWH(img)
    img2 = Float32.(img2)
    #img2 = cv.Mat(img2)
end

"""
rs2opencv(img)

Converts images from pyrealsense to OpenCV type of representation.
"""
function rs2opencv(img)
    img2 = Float32.(img) ./ Float32(255.0)
    img2 = Images.permutedims(img2, (3, 2, 1))
end



"""
hex2rgb(img)

Converts images from hex-3D-array to RGB-2D representation.
"""
function hex2rgb(img)
    img2 = Float32.(img) ./ Float32(255.0)
    img2 = RGB.(img2[:,:,1], img2[:,:,2], img2[:,:,3])
end



"""
hex2uint8(img)

Converts images from RGB-2D to uint8 representation.
"""
function rgb2uint8(img)
    img2 = rgb2HWC(img)
    img2 = reinterpret(UInt8, img2) .|> UInt8    
end



"""
cvShowImage(imageFullPath, windowName)

Uses OpenCV to show a single image on a window.
"""
function cvShowImage(imageFullPath, windowName)
    img = cv.imread(imageFullPath)   # no need to convert file, read with OpenCV
    cv.imshow(windowName, img)
    cv.waitKey(Int32(0))
    cv.destroyWindow(windowName)
end



"""
cvPlayImageBuffer(imageBuffer, windowName, framesPerSecond)

Uses OpenCV to play a sequence of RGB-2D images in a buffer as video, on a window.
"""
function cvPlayImageBuffer(imageBuffer, windowName, framesPerSecond)
    frameInterval_ms = trunc( Int32, Float32(1.0 / framesPerSecond * 1000.0) )

    for img in imageBuffer
        img = rgb2opencv(img)
        cv.imshow(windowName, img)
        cv.waitKey(frameInterval_ms)
    end
    cv.destroyWindow(windowName)
end



end