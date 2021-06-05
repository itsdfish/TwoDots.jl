mutable struct Dot
    color::Symbol
    selected::Bool
    row::Int
    col::Int
end

function Dot(;color=:_, selected=false, col, row)
    Dot(color, selected, row, col)
end

mutable struct Game
    dots::Array{Dot,2}
    selected_dots::Vector{Dot}
    rounds::Int
    round::Int
    score::Int
    visible::Bool
end

function Game(;n_rows=20, n_cols=20, rounds=30, visible=true)
    dots = populate(n_rows, n_cols)
    #rand_color!.(dots)
    Game(dots, Dot[], rounds, 1, 0, visible)
end