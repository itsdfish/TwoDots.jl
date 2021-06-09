using SafeTestsets

@safetestset "is rectangular" begin
    using Test, TwoDots
    import TwoDots: is_rectangular
    game = Game()
    map(x->x.color = "green", game.dots)
    push!(game.selected_dots, game.dots[1,1])
    push!(game.selected_dots, game.dots[2,1])
    push!(game.selected_dots, game.dots[3,1])
    map(x->x.selected = true, game.selected_dots)
    @test !is_rectangular(game)

    game = Game()
    map(x->x.color = "green", game.dots)
    push!(game.selected_dots, game.dots[1,1])
    map(x->x.selected = true, game.selected_dots)
    @test !is_rectangular(game)

    game = Game()
    map(x->x.color = "green", game.dots)
    push!(game.selected_dots, game.dots[1,1])
    push!(game.selected_dots, game.dots[1,2])
    push!(game.selected_dots, game.dots[1,3])
    map(x->x.selected = true, game.selected_dots)
    @test !is_rectangular(game)

    game = Game()
    map(x->x.color = "green", game.dots)
    push!(game.selected_dots, game.dots[1,1])
    push!(game.selected_dots, game.dots[1,2])
    push!(game.selected_dots, game.dots[1,3])
    push!(game.selected_dots, game.dots[2,3])
    map(x->x.selected = true, game.selected_dots)
    @test !is_rectangular(game)

    game = Game()
    map(x->x.color = "green", game.dots)
    push!(game.selected_dots, game.dots[1,1])
    push!(game.selected_dots, game.dots[1,2])
    push!(game.selected_dots, game.dots[1,3])
    push!(game.selected_dots, game.dots[2,3])
    push!(game.selected_dots, game.dots[2,2])
    map(x->x.selected = true, game.selected_dots)
    @test is_rectangular(game)

    game = Game()
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

@safetestset "click submit" begin
    using Test, TwoDots
    import TwoDots: click_submit

    game = Game(n_rows=6, n_cols=2)
    game.dots[1,1].color = "green"
    game.dots[2,1].color = "red"
    game.dots[3,1].color = "yellow"
    game.dots[4,1].color = "green"
    game.dots[5,1].color = "purple"
    game.dots[6,1].color = "orange"
    map(x->x.color = "green", game.dots[:,2])

    push!(game.selected_dots, game.dots[3,1])
    push!(game.selected_dots, game.dots[5,1])

    click_submit(game)

    @test isempty(game.selected_dots)

    @test game.dots[3,1].color == "green"
    @test game.dots[4,1].color == "red"
    @test game.dots[5,1].color == "green"
    @test game.dots[6,1].color == "orange"

    @test all(x->x.color == "green", game.dots[:,2])

    game = Game(n_rows=6, n_cols=2)
    game.dots[1,1].color = "green"
    game.dots[2,1].color = "red"
    game.dots[3,1].color = "yellow"
    game.dots[4,1].color = "green"
    game.dots[5,1].color = "purple"
    game.dots[6,1].color = "orange"
    map(x->x.color = "green", game.dots[:,2])

    # opposite order
    push!(game.selected_dots, game.dots[5,1])
    push!(game.selected_dots, game.dots[3,1])

    click_submit(game)

    @test isempty(game.selected_dots)

    @test game.dots[3,1].color == "green"
    @test game.dots[4,1].color == "red"
    @test game.dots[5,1].color == "green"
    @test game.dots[6,1].color == "orange"

    @test all(x->x.color == "green", game.dots[:,2])
end