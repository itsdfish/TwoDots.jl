function rand_color!(x::Dot)
    x.color = rand(["red","blue","yellow","green","orange"])
    return nothing
end

populate(n_rows, n_cols) = [Dot(;row, col) for row in 1:n_rows, col in 1:n_cols]