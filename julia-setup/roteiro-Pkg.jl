# libraries
using Pkg
using PkgTemplates

# path
libPath = "/home/ciro/projects/libjulia"
libraryName = "libImageArrays.jl"
libString = string(libPath, "/", libraryName)

# create package
t=Template(user="cirobr",   # github username
           authors="Ciro B Rosa <ciro.rosa@alumni.usp.br>", 
           julia=v"1.6.5",
           dir=libPath)   #libPath[1 : end-3])
t(libraryName)

# add dependencies
# Pkg.activate(libString)
# Pkg.add("Images") 
# Pkg.add("OpenCV") 
