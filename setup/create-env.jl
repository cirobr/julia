# libraries
using Pkg
using PkgTemplates

# library name
lib      = "Mylib"   # replace by the actual package name
path     = expanduser("~/projects/")
fullpath = path * lib

# create package
t=Template(user="cirobr",   # github username
           authors="Ciro B Rosa <ciro.rosa@alumni.usp.br>", 
           julia=v"1.8.2",
           dir=path)
t(lib)

# add dependencies
Pkg.activate(fullpath)
Pkg.add("Flux") 
Pkg.add("CUDA") 

mv(fullpath, fullpath*".jl")