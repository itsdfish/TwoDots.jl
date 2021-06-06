using Pkg 
cd(@__DIR__)
Pkg.activate("..")
using Revise, TwoDots

game = Game()
gui = generate_gui(game)
