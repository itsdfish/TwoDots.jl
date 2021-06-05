module TwoDots
    using Gtk, Cairo
    export Dot, Game, generate_gui
    
    include("structs.jl")
    include("functions.jl")
    include("gui.jl")
end
