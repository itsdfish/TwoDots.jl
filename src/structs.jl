mutable struct Dot
    color::String
    selected::Bool
    row::Int
    col::Int
end

function Dot(;color="", selected=false, col, row)
    Dot(color, selected, row, col)
end

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
