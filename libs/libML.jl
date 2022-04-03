# Library to support preprocessing of AI/ML tasks
module libML



"""
rescaleByColumns(X::Matrix)

Centers and Rescales predictors from input matrix by columns.
"""
function rescaleByColumns(X::Matrix)
    # using StatsBase
    X = Float32.(X)
    dt = StatsBase.fit(ZScoreTransform, X; dims=1, center=true, scale=true)
    rescaledX = StatsBase.transform(dt, X)
end



"""
rescaleByRows(X::Matrix)

Centers and Rescales predictors from input matrix by rows.
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



end