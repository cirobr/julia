### run this code from the "projects" folder ###

# libraries
using Pkg
using PkgTemplates

# library name
lib      = "UnetFlux"
fullpath = "~/projects"

# create package
t=Template(user="cirobr",   # github username
           authors="Ciro B Rosa <ciro.rosa@alumni.usp.br>", 
           julia=v"1.6.7",
           dir=fullpath)
t(lib)

# add dependencies
Pkg.activate(lib)
Pkg.add("Flux") 
Pkg.add("CUDA") 

mv(lib, lib * ".jl")