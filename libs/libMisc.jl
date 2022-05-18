using MLJ

function filesWithinFolder(folder, prefix, ext)
    cutoffName = length(prefix) + 1
    files = readdir(folder)
    extFiles = [file for file in files if occursin( ext, file )]
    sortedExtFiles = sort( [ parse(Int, file[cutoffName : end-4])  for file in extFiles ] )
    sortedExtFiles = string.(folder, "/", prefix, sortedExtFiles, ext)
end


function printMetrics(ŷ, y)
    display(confmat(ŷ, y))
    println("accuracy: ", round(accuracy(ŷ, y); digits=3))
    println("f1-score: ", round(multiclass_f1score(ŷ, y); digits=3))
end