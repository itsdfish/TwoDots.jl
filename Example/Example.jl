using Pkg 
cd(@__DIR__)
Pkg.activate("..")
using Revise, TwoDots

game = Game(;n_rows=8, n_cols=8)

#map(x->x.color = "green", game.dots)

gui = generate_gui(game)
