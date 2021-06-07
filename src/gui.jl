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

start_new_game!(x, gui, game) = start_new_game!(gui, game)

function start_new_game!(gui, game)
    game.score = 0
    game.round = game.n_rounds
    rand_color!.(game.dots)
    map(x->x.selected = false, game.dots)
    clear_selected!(game)
    remove_components!(gui)
    generate_gui!(game, gui)
end

function generate_gui(; width=700, height=600)
    game = Game()
    generate_gui(game; width, height)
end

function generate_gui(game; width=700, height=600)
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

    round_count = GtkLabel(string(game.round), name="round_count")
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
    set_gtk_property!(label, :name, string(dot.color,"_clicked"))
end

function make_all_grey!(gui, game, style)
    for (button,dot) in zip(gui[1][3],game.dots)
        make_grey!(button, dot, style)
    end
    return nothing
end

function click_submit(button, game, style, gui)
    game_over!(game) ? (return nothing) : nothing
    not_connected(game) ? (return nothing) : nothing
    update_round!(game, gui)
    if is_rectangular(game)
        game.selected_dots = select_all_color!(game)
    end
    update_score!(game, gui)
    sort_by_row!(game)
    shift_colors!(game, gui, style)
    set_unselected!(game)
    clear_selected!(game)
    game_over!(game) ? make_all_grey!(gui, game, style) : nothing
    return nothing
end

sort_by_row!(game::Game) = sort_by_row!(game.selected_dots)

function sort_by_row!(dots)
    rows = map(x->x.row, dots)
    idx = sortperm(rows)
    dots .= dots[idx]
end

not_connected(game) = length(game.selected_dots) < 2

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

function update_round!(game, gui)
    update_round!(game)
    score = gui[1][2][2]
    set_gtk_property!(score, :label, string(game.round))
end 

function update_score!(game, gui)
    update_score!(game)
    counter = gui[1][2][4]
    set_gtk_property!(counter, :label, string(game.score))
    return nothing
end

function remove_components!(gui)
    for g in gui
        delete!(gui, g)
    end
end