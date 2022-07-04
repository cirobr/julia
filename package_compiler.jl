using PackageCompiler
@time create_sysimage([:Plots], sysimage_path="sysimage_plots.so")
# julia --project --sysimage sysimage_plots.so


@time create_sysimage([:Plots], sysimage_path="sysimage_plots.so",
                                precompile_execution_file="using_plots.jl")


v=[:Plots;
   :Images;
   :OpenCV;
   :GLMakie;
   :VideoIO]
@time create_sysimage(v, sysimage_path="sysimage_imgs.so")