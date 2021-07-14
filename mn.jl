using MLDatasets
using ImageCore
using Plots

train_x, train_y = MNIST.traindata()
test_x,  test_y  = MNIST.testdata()

seq = rand(1: 60000)    # pick a number within range
x = train_x[:,:,seq]
y = train_y[seq]

print(y)                # print after plot not showing at vscode
img = MNIST.convert2image(x)
plot(img)
