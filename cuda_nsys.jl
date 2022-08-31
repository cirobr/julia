using CUDA
a = CUDA.rand(1024,1024,1024);
sin.(a);
CUDA.@profile sin.(a);