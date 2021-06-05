function generate_gui()
    game = Game()
    generate_gui(game)
end

function generate_gui(game)
    win = GtkWindow("Two Dots")
    generate_gui!(game, win)
    return win
end

function generate_gui!(game, win)
    menu_bar = setup_menu(win, game)
    g = GtkGrid(name="grid")
    base_panel = GtkBox(:v, name="base_panel")
    info_panel = GtkBox(:h, name="info_panel")
    push!(base_panel, menu_bar)
    push!(base_panel, info_panel)
    set_gtk_property!(info_panel, :spacing, 30)
    label = GtkLabel("Rounds ", name="rounds_label")
    push!(info_panel, label)
    round_count = GtkLabel(string(game.rounds), name="round_count")
    push!(info_panel, round_count)
    score_label = GtkLabel("Score", name="score_label")
    push!(info_panel, score_label)
    score_value = GtkLabel("0", name="score_value")
    push!(info_panel, score_value)
    push!(base_panel, g)
    submit_button = GtkButton("Submit")
    signal_connect(x->click_submit(x, game, win), submit_button, "clicked")
    push!(base_panel, submit_button)
    n_rows,n_cols = size(game.dots)
    for r in 1:n_rows, c in 1:n_cols
        b = GtkButton("")
        g[r,c] = b
        signal_connect(x->click_dot(x, game, win, game.dots[c,r]), b, "clicked")
    end
    set_gtk_property!(g, :column_spacing, 5)
    set_gtk_property!(g, :row_spacing, 5)
    set_gtk_property!(g, :column_homogeneous, true)
    set_gtk_property!(g, :row_homogeneous, true)
    set_gtk_property!(g, :expand, true)
    set_gtk_property!(info_panel, :pack_type, label, 0)

    push!(win, base_panel)
    showall(win)
end

function setup_menu(gui, game)
    mb = GtkMenuBar(name="menu_bar")
    file = GtkMenuItem("_File")
    file_menu = GtkMenu(file, name="file_menu")
    new_game = GtkMenuItem("New Game", name="new_game")
    signal_connect(x->start_new_game!(x, gui, game), new_game, :activate)
    push!(file_menu, new_game)
    setup = GtkMenuItem("Setup", name="setup")
    signal_connect(x->setup_game(x, game, gui), setup, :activate)
    push!(file_menu, setup)
    push!(mb, file)
    return mb
end

function click_submit(button, game, gui)
    update_score!(game)
    update_score!(game, gui)
end

function update_score!(game)
    game.score += length(game.selected_dots)
end

function update_score!(game, gui)
    counter = gui[1][2][4]
    set_gtk_property!(counter, :label, string(game.score))
    return nothing
end

function click_dot(button, game, gui, dot)
    !can_select(game, dot) ? (return nothing) : nothing
    println(game.selected_dots)
    if dot.selected
        dot.selected = false
        remove_dot!(game, dot)
        # change color
    else
        dot.selected = true
        add_dot!(game, dot)
        # change color
    end
    return nothing
end

function can_select(game, dot)
    dots = game.selected_dots
    # first dot
    if isempty(dots)
        println("first dot")
        return true 
    end
    # unclick last last clicked dot
    if dot == dots[end]
        println("last dot added")
        return true 
    end
    # cannot select dot again
    if dot ∈ dots
        println("is member of set")
        return false 
    end
    # colors do not match
    if dots[end].color != dot.color
        println("colors do not match")
        return false
    end
    # not adjecent 
    if !is_adjecent(dots[end], dot)
        println("not adjecent")
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


remove_dot!(game::Game, dot) = remove_dot!(game.selected_dots, dot)

function remove_dot!(selected_dots, dot)
    filter!(x->x == dot, selected_dots)
end

add_dot!(game::Game, dot) = add_dot!(game.selected_dots, dot)

function add_dot!(selected_dots, dot)
    push!(selected_dots, dot)
end
