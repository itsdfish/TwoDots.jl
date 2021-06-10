"""
    Dot(;color="", selected=false, col, row)

Generates a dot object containing the following elements:

- `color`: color of dot
- `selected`: dot is selected if true
- `row`: row index 
- `col`: col index 
"""
mutable struct Dot
    color::String
    selected::Bool
    row::Int
    col::Int
end

function Dot(;color="", selected=false, col, row)
    Dot(color, selected, row, col)
end

"""
    Game(;n_rows=8, n_cols=8, n_rounds=30, round=n_rounds, visible=true)

Generates a game object containing the following elements:

- `dots`: an array of dots representing the board
- `selected_dots`: an array of selected dots
- `n_rounds`: the number of rounds in a game 
- `round`: current round 
- `score`: the number of connected dots
- `visible`: display GUI if true
"""
mutable struct Game
    dots::Array{Dot,2}
    selected_dots::Vector{Dot}
    n_rounds::Int
    round::Int
    score::Int
    visible::Bool
end

function Game(;n_rows=8, n_cols=8, n_rounds=30, round=n_rounds, visible=true)
    dots = populate(n_rows, n_cols)
    rand_color!.(dots)
    Game(dots, Dot[], n_rounds, round, 0, visible)
end

Broadcast.broadcastable(x::Game) = Ref(x)

mutable struct GUI{G,S}
    gui::G
    style::S
end

function GUI(;width=700, height=600, game = Game())
    gui = GtkWindow("Two Dots", width, height)
    filename = joinpath(@__DIR__, "style.css")
    style = CssProviderLeaf(;filename)
    generate_gui!(game, gui, style)
    GUI(gui, style)
end
