using SafeTestsets

@safetestset "is rectangular" begin
    using Test, TwoDots
    import TwoDots: is_rectangular
    game = Game(;n_rows=8, n_cols=8)
    map(x->x.color = "green", game.dots)
    push!(game.selected_dots, game.dots[1,1])
    push!(game.selected_dots, game.dots[2,1])
    push!(game.selected_dots, game.dots[3,1])
    map(x->x.selected = true, game.selected_dots)
    @test !is_rectangular(game)

    game = Game(;n_rows=8, n_cols=8)
    map(x->x.color = "green", game.dots)
    push!(game.selected_dots, game.dots[1,1])
    map(x->x.selected = true, game.selected_dots)
    @test !is_rectangular(game)

    game = Game(;n_rows=8, n_cols=8)
    map(x->x.color = "green", game.dots)
    push!(game.selected_dots, game.dots[1,1])
    push!(game.selected_dots, game.dots[1,2])
    push!(game.selected_dots, game.dots[1,3])
    map(x->x.selected = true, game.selected_dots)
    @test !is_rectangular(game)

    game = Game(;n_rows=8, n_cols=8)
    map(x->x.color = "green", game.dots)
    push!(game.selected_dots, game.dots[1,1])
    push!(game.selected_dots, game.dots[1,2])
    push!(game.selected_dots, game.dots[1,3])
    push!(game.selected_dots, game.dots[2,3])
    map(x->x.selected = true, game.selected_dots)
    @test !is_rectangular(game)

    game = Game(;n_rows=8, n_cols=8)
    map(x->x.color = "green", game.dots)
    push!(game.selected_dots, game.dots[1,1])
    push!(game.selected_dots, game.dots[1,2])
    push!(game.selected_dots, game.dots[1,3])
    push!(game.selected_dots, game.dots[2,3])
    push!(game.selected_dots, game.dots[2,2])
    map(x->x.selected = true, game.selected_dots)
    @test is_rectangular(game)

    game = Game(;n_rows=8, n_cols=8)
    map(x->x.color = "green", game.dots)
    push!(game.selected_dots, game.dots[1,1])
    push!(game.selected_dots, game.dots[1,2])
    push!(game.selected_dots, game.dots[1,3])
    push!(game.selected_dots, game.dots[2,3])
    push!(game.selected_dots, game.dots[3,3])
    push!(game.selected_dots, game.dots[3,2])
    push!(game.selected_dots, game.dots[3,1])
    push!(game.selected_dots, game.dots[2,1])
    map(x->x.selected = true, game.selected_dots)
    @test is_rectangular(game)
end
