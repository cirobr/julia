module libjlrealsense



function rsSetupBagfile(file)
    # setup
    global pipe = rs.pipeline()
    global cfg = rs.config()
    cfg.enable_device_from_file(file, repeat_playback=false)   # false prevents file replay
    global profile = pipe.start(cfg)

    # get stream types
    global streamProfiles = rsGetProfiles(pipe)

    # setup file for streaming
    global playback = profile.get_device().as_playback()   # get playback device
    playback.set_real_time(false)                   # disable real-time playback (reading from file)
end



function rsGetProfiles(pipe)
    profiles = ["Color", "Infrared", "Depth"]

    activeProfile = pipe.get_active_profile()
    streams = activeProfile.get_streams()

    streamProfiles = []
    for stream in streams
        for profile in profiles
            if occursin(profile, string(stream))
                push!(streamProfiles, profile)
            end
        end
    end

    return (streamProfiles)
end



function rsShowInfo(pipe)
    activeProfile = pipe.get_active_profile()
    println(activeProfile.get_device())
    println(activeProfile.get_streams())
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
    img = Array{UInt8}[]
    dpt = Matrix{UInt16}[]
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



end