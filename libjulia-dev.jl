# libraries
using DataFrames
using MLDataUtils



RMSE(ŷ, y) = mean(abs.(ŷ - y))



function categoryStratificationChart(trainY, testY)
    # check for unique labels
    l = label(trainY); sort!(l)
    N = nlabel(trainY)

    # trainset classes
    d1 = labelfreq(trainY)
    d1 = DataFrame([(k, v) for (k,v) in d1])
    rename!(d1, ["class","trainset"])

    # testset classes
    d2 = labelfreq(testY)
    d2 = DataFrame([(k, v) for (k,v) in d2])
    rename!(d2, ["class","testset"])

    # make a single df (df facilitates sorting)
    df = leftjoin(d1, d2, on = :class)
    sort!(df,[:class])

    # make a matrix out of df (matrix facilitates plotting)
    M = df |> Array
    p1 = groupedbar(M[:, 2:3],
        bar_position = :dodge,
        size=(500,300),
        xtick=(1:N, l),   # não é obvio chegar a esta configuração
        legend=:outerright,
        label=["trainset" "testset"])
    p1 = title!("Dataset stratification", xlabel="categories", ylabel="count")
end



function matrix2Vector(M)
    d = length(M)
    v = reshape(M, (d,))   # columns are organized left-to-right as single vector
end



function vectorVectors2Matrix(M, tr=true)
    Mnew = DataFrame(M, :auto) |> Matrix
    if tr Mnew = Mnew' end
    
    return Mnew
end



function vectorVectors2DF(M, tr=true)
    Mnew = DataFrame(M, :auto) |> Matrix
    Mnew = DataFrame(Mnew', :auto)
end



function imageSet2DF(imageSet)
    # converts an image set (h x v x N) array on a DataFrame
    # each row of the dataframe corresponds to one vector image

    N = size(imageSet)[3]
    d = size(imageSet)[1] * size(imageSet)[2]

    X = [ matrix2Vector(imageSet[:, :, i]) for i in 1:N ]
    X = DataFrame(X, :auto) |> Matrix
    df = DataFrame(X', :auto)
end



function imageSet2Matrix(imageSet)
    # converts an image set (h x v x N) array on a (vector x N) array
    # each row of the dataframe corresponds to one vector image

    N = size(imageSet)[3]
    d = size(imageSet)[1] * size(imageSet)[2]

    X = [ matrix2Vector(imageSet[:, :, i]) for i in 1:N ]
    X = DataFrame(X, :auto) |> Matrix
    return X'
end



function shuffleRowMatrix(X, Y)
    ndim = size(Y)[1]
    ind = randperm(ndim)   # shuffle array indices
    shuffledX = X[ind, :]
    shuffledY = trainY[ind]
    
    return (shuffledX, shuffledY)
end



function rescaleByColumns(X)
    # using StatsBase
    X = Float64.(X)
    dt = StatsBase.fit(ZScoreTransform, X; dims=1, center=true, scale=true)
    rescaledX = StatsBase.transform(dt, X)
end



function rescaleByRows(X)
    # using StatsBase
    X = Float64.(X)
    dt = fit(ZScoreTransform, X; dims=2, center=true, scale=true)
    rescaledX = StatsBase.transform(dt, X)
end



