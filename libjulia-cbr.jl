# libraries
using StatsBase
using DataFrames
using MLDataUtils

using PyCall
rs  = pyimport("pyrealsense2")
cv2 = pyimport("cv2")            # video playback only



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



# realsense functions
function rsShowInfo(pipe)
    activeProfile = pipe.get_active_profile()
    println(activeProfile.get_device())
    println(activeProfile.get_streams())
    
end

function rsGetProfiles(pipe)
    profiles = ["Color", "Infrared", "Depth"]

    activeProfile = pipe.get_active_profile()
    streams = activeProfile.get_streams()
    
    streamProfiles = []
    for stream in streams
        for profile in profiles
            if occursin( profile, string(stream) )
                push!(streamProfiles, profile)
            end
        end
    end

    return (streamProfiles)
end

function rsAlignFrames(profiles)
    if "Color" in profiles
        align = rs.align(rs.stream.color)      # alignment color & depth
    elseif "Infrared" in profiles
        align = rs.align(rs.stream.infrared)   # alignment infrared & depth
    end
    
    return (align)
end

function rsDecodeFrames(frameset, profiles)
    img  = Array{UInt8}[]
    dpt  = Matrix{UInt16}[]
    cdpt = Array{UInt8}[]
    
    for profile in profiles
        if profile == "Color"
            colorFrame = frameset.get_color_frame()
            img = colorFrame.get_data() |> Array
            
        elseif profile == "Infrared"
            grayFrame = frameset.get_infrared_frame()
            img = grayFrame.get_data() |> Array
            
        elseif profile == "Depth"
            depthFrame = frameset.get_depth_frame()
            dpt = depthFrame.get_data() |> Array

            colorizer = rs.colorizer()
            cdpt = colorizer.colorize(depthFrame).get_data() |> Array

        end
    end

    return (img, dpt, cdpt)
end

function rsProcessBagfile(file, imageBuffer, folderName, sleepTime_s, saveFrames=false)
    # setup
    pipe    = rs.pipeline()
    cfg     = rs.config()
    cfg.enable_device_from_file(file, repeat_playback=false)   # false prevents file replay
    profile = pipe.start(cfg)
        
    # get stream types
    streamProfiles = rsGetProfiles(pipe)

    # setup file for streaming
    playback = profile.get_device().as_playback()   # get playback device
    playback.set_real_time(false)                   # disable real-time playback (reading from file)
        
    frameNumber = 0
    playback.resume()   # ensures loop start
    print("Processing file ", file, " ... ")
                
    while playback.current_status() == rs.playback_status.playing
        # decode single frame
        frameset       = pipe.wait_for_frames()                     # get frame
        align          = rsAlignFrames(streamProfiles)              # align frame
        frameset       = align.process(frameset)
        img, dpt, cdpt = rsDecodeFrames(frameset, streamProfiles)   # decode frame
            
        # add frame to buffer
        frameNumber += 1
        push!(imageBuffer, img)

        # save frame to png file
        if saveFrames
            fileName  = string.(folderName, "/", "img", frameNumber, ".png")
            Images.save(fileName, img)
        end
    
        # pause between frames
        if sleepTime_s >= 0.001 sleep(sleepTime_s) end
    end
        
    # cleanup
    pipe.stop()
    println(frameNumber, " frames processed")
end



function cv2PlayImageBuffer(imageBuffer, windowName, framesPerSecond)
    frameInterval_ms = trunc( Int16, Float32(1.0 / framesPerSecond * 1000.0) )

    for img in imageBuffer
        cv2.imshow(windowName, img)
        cv2.waitKey(frameInterval_ms)
    end
    cv2.destroyWindow(windowName);
end