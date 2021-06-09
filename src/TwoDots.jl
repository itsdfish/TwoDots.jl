"""
# TwoDots

The goal of TwoDots is to earn as many points as possible by connecting dots of the same color. If the connected dots form a rectangle, all of the dots of that color count towards your points. Click on the dots you want to connect and click submit. 

# Example

```julia
using TwoDots
start()
```
"""
module TwoDots
    using Gtk, Cairo, Gtk.ShortNames
    export Dot, Game, GUI, start
    export click_dot!, click_submit!, can_select
    
    include("structs.jl")
    include("functions.jl")
    include("gui.jl")
end
