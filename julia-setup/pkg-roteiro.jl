# libraries
using Pkg
using PkgTemplates

# library name
libName  = "AnaliseAlgoritmos.jl"
fullpath = "~/projects/libjulia"
lib      = libName[1:end-3]

# create package
t=Template(user="cirobr",   # github username
           authors="Ciro B Rosa <ciro.rosa@alumni.usp.br>", 
           julia=v"1.6.6",
           dir=fullpath)
t(lib)

# add dependencies
# Pkg.activate(lib)
# Pkg.add("Images") 
# Pkg.add("OpenCV") 
