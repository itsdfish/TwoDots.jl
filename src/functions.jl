function click_dot!(game, dot)
    !can_select(game, dot) ? (return false) : nothing
    dot.updated = false
    if dot.selected
        dot.selected = false
        remove_dot!(game, dot)
    else
        dot.selected = true
        add_dot!(game, dot)
    end
    return true
end

function can_select(game, dot)
    game_over!(game) ? (return false) : nothing
    dots = game.selected_dots
    # first dot
    if isempty(dots)
        return true 
    end
    # unclick last last clicked dot
    if dot == dots[end]
        return true 
    end
    # cannot select dot again
    if dot ∈ dots
        return false 
    end
    # colors do not match
    if dots[end].color != dot.color
        return false
    end
    # not adjecent 
    if !is_adjecent(dots[end], dot)
        return false
    end
    return true
end

function is_adjecent(dot1, dot2)
    if (dot1.row + 1 == dot2.row) && (dot1.col == dot2.col)
        return true 
    end 
    if (dot1.row - 1 == dot2.row) && (dot1.col == dot2.col)
        return true 
    end 
    if (dot1.row == dot2.row) && (dot1.col == dot2.col + 1)
        return true 
    end 
    if (dot1.row  == dot2.row) && (dot1.col == dot2.col - 1)
        return true 
    end 
    return false
end

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

function rand_color!(x::Dot)
    x.color = rand(["red","blue","yellow","green","orange"])
    return nothing
end

populate(n_rows, n_cols) = [Dot(;row, col) for row in 1:n_rows, col in 1:n_cols]

game_over!(game) = game.round == 0

set_unselected!(game::Game) = set_unselected!(game.selected_dots)

function set_unselected!(dots)
    map(x->x.selected=false, dots)
end

function update_score!(game)
    game.score += length(game.selected_dots)
end

function update_round!(game)
    game.round -= 1
end

remove_dot!(game::Game, dot) = remove_dot!(game.selected_dots, dot)

function remove_dot!(selected_dots, dot)
    filter!(x->x != dot, selected_dots)
end

add_dot!(game::Game, dot) = add_dot!(game.selected_dots, dot)

function add_dot!(selected_dots, dot)
    push!(selected_dots, dot)
end

select_all_color!(game) = select_all_color!(game.dots, game.selected_dots)

function select_all_color!(dots, selected_dots)
    color = selected_dots[1].color
    color_dots = filter(x->x.color == color, dots)
    map(x->x.selected = true, color_dots)
    return color_dots
end

function clear_selected!(game)
    empty!(game.selected_dots)
end

sort_by_row!(game::Game) = sort_by_row!(game.selected_dots)

function sort_by_row!(dots)
    rows = map(x->x.row, dots)
    idx = sortperm(rows)
    dots .= dots[idx]
end

not_connected(game) = length(game.selected_dots) < 2

function shift_colors!(game)
    for dot in game.selected_dots
        shift_color!(dot, game)
    end
end

function shift_color!(dot, game)
    dots = game.dots
    row = dot.row
    col = dot.col
    while (row > 1)
        dots[row,col].color = dots[row-1,col].color
        row -= 1
    end
    rand_color!(dots[row,col])
end

click_submit!(game, gui::Nothing, button, style) = click_submit!(game)

function click_submit!(game)
    game_over!(game) ? (return false) : nothing
    not_connected(game) ? (return false) : nothing
    update_round!(game)
    if is_rectangular(game)
        game.selected_dots = select_all_color!(game)
    end
    update_score!(game)
    sort_by_row!(game)
    shift_colors!(game)
    set_unselected!(game)
    clear_selected!(game)
    return true
end