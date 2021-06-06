function generate_gui(; width=1500, height=600)
    game = Game()
    generate_gui(game; width, height)
end

function generate_gui(game; width=1500, height=600)
    win = GtkWindow("Two Dots", width, height)
    generate_gui!(game, win)
    return win
end

function generate_gui!(game, win)
    style = CssProviderLeaf(filename = "../src/style.css")
    base_panel = GtkBox(:v, name="base_panel")
    menu_bar = setup_menu(win, game)
    push!(base_panel, menu_bar)

    info_panel = GtkBox(:h, name="info_panel")
    sc = Gtk.GAccessor.style_context(info_panel)
    set_gtk_property!(info_panel, :spacing, 30)
    push!(base_panel, info_panel)
    push!(sc, StyleProvider(style), 600)

    label = GtkLabel("Rounds ", name="rounds_label")
    sc = Gtk.GAccessor.style_context(label)
    push!(sc, StyleProvider(style), 600)
    push!(info_panel, label)

    round_count = GtkLabel(string(game.rounds), name="round_count")
    sc = Gtk.GAccessor.style_context(round_count)
    push!(sc, StyleProvider(style), 600)
    push!(info_panel, round_count)
    
    score_label = GtkLabel("Score", name="score_label")
    sc = Gtk.GAccessor.style_context(score_label)
    push!(sc, StyleProvider(style), 600)
    push!(info_panel, score_label)

    score_value = GtkLabel("0", name="score_value")
    sc = Gtk.GAccessor.style_context(score_value)
    push!(sc, StyleProvider(style), 600)
    push!(info_panel, score_value)

    g = GtkGrid(name="grid")
    push!(base_panel, g)

    submit_button = GtkButton(name="submit_button")
    submit_label = GtkLabel("Submit", name="submit_label")
    push!(submit_button, submit_label)
    sc = Gtk.GAccessor.style_context(submit_label)
    push!(sc, StyleProvider(style), 600)
    
    push!(base_panel, submit_button)
    signal_connect(x->click_submit(x, game, style, win), submit_button, "clicked")

    n_rows,n_cols = size(game.dots)
    for r in 1:n_rows, c in 1:n_cols
        b = GtkButton("")
        dot = game.dots[r,c]
        label = GtkLabel("•")
        push!(b, label)
        add_color!(b, dot, style)
        g[c,r] = b
        signal_connect(x->click_dot(x, game, win, style, dot), b, "clicked")
    end
    set_gtk_property!(g, :column_spacing, 5)
    set_gtk_property!(g, :row_spacing, 5)
    set_gtk_property!(g, :column_homogeneous, true)
    set_gtk_property!(g, :row_homogeneous, true)
    set_gtk_property!(g, :expand, true)
    #set_gtk_property!(info_panel, :fill, label, 0)
    
    push!(win, base_panel)
    showall(win)
end

function add_color!(button, dot, style)
    label = button[1]
    sc = Gtk.GAccessor.style_context(label)
    push!(sc, StyleProvider(style), 600)
    set_gtk_property!(label, :name, dot.color)
end

function make_grey!(button, dot, style)
    label = button[1]
    sc = Gtk.GAccessor.style_context(label)
    push!(sc, StyleProvider(style), 600)
    set_gtk_property!(label, :name, "grey")
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

function click_submit(button, game, style, gui)
    update_score!(game)
    update_score!(game, gui)
    shift_colors!(game, gui, style)
    set_unselected!(game)
    clear_selected!(game)
end

function clear_selected!(game)
    empty!(game.selected_dots)
end

function shift_colors!(game, gui, style)
    for dot in game.selected_dots
        shift_color!(dot, game, gui, style)
    end
end

function shift_color!(dot, game, gui, style)
    dots = game.dots
    row = dot.row
    col = dot.col
    buttons = gui[1][3] 
    while (row > 1)
        dots[row,col].color = dots[row-1,col].color
        add_color!(buttons[col,row], dots[row,col], style)
        row -= 1
    end
    rand_color!(dots[row,col])
    add_color!(buttons[col,row], dots[row,col], style)
end

set_unselected!(game::Game) = set_unselected!(game.selected_dots)

function set_unselected!(dots)
    map(x->x.selected=false, dots)
end

function update_score!(game)
    game.score += length(game.selected_dots)
end

function update_score!(game, gui)
    counter = gui[1][2][4]
    set_gtk_property!(counter, :label, string(game.score))
    return nothing
end

function click_dot(button, game, gui, provider, dot)
    !can_select(game, dot) ? (return nothing) : nothing
    if dot.selected
        dot.selected = false
        remove_dot!(game, dot)
        add_color!(button, dot, provider)
    else
        dot.selected = true
        add_dot!(game, dot)
        make_grey!(button, dot, provider)
    end
    return nothing
end

function can_select(game, dot)
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

remove_dot!(game::Game, dot) = remove_dot!(game.selected_dots, dot)

function remove_dot!(selected_dots, dot)
    filter!(x->x != dot, selected_dots)
end

add_dot!(game::Game, dot) = add_dot!(game.selected_dots, dot)

function add_dot!(selected_dots, dot)
    push!(selected_dots, dot)
end
