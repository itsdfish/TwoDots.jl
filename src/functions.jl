function rand_color!(x::Dot)
    x.color = rand(["red","blue","yellow","green","orange"])
    return nothing
end

populate(n_rows, n_cols) = [Dot(;row, col) for row in 1:n_rows, col in 1:n_cols]


function max_coords(dots)
    min_row = minimum(x->x.row, dots)
    max_row = maximum(x->x.row, dots)
    min_col = minimum(x->x.col, dots)
    max_col = maximum(x->x.col, dots)
    return min_row, max_row, min_col, max_col
end

is_rectangular(game) = is_rectangular(game.selected_dots, game.dots)

function is_rectangular(selected_dots, dots)
    min_row, max_row, min_col, max_col = max_coords(selected_dots)
    if ((max_row - min_row) == 0) || ((max_col - min_col) == 0)
        return false 
    end 
    return rectangle_sizes(dots, min_row, max_row, min_col, max_col)
end

function rectangle_sizes(dots, min_row, max_row, min_col, max_col)
    max_height = max_row - min_row + 1
    max_width = max_col - min_col + 1
    for width in 2:max_width 
        for height in 2:max_height 
            if rectangle_offset(dots, width, height, min_row, max_height, min_col, max_width)
                return true 
            end 
        end
    end
    return false 
end

function rectangle_offset(dots, width, height, min_row, max_height, min_col, max_width)
    for c in 0:(max_width - width)
        for r in 0:(max_height - height)
            if trace_rectangle(
                    dots, 
                    min_row + r, 
                    height + min_row + r - 1, 
                    min_col + c, 
                    width + min_col + c - 1
                )
                return true
            end
        end
    end
    return false
end

function trace_rectangle(dots, min_row, max_row, min_col, max_col)
    for r in [min_row,max_row]
        for c in min_col:max_col
            !dots[r,c].selected ? (return false) : nothing
        end 
    end
    for c in [min_col,max_col]
        for r in min_row:max_row
            !dots[r,c].selected ? (return false) : nothing
        end 
    end
    return true
end