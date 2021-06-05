using Pkg 
cd(@__DIR__)
Pkg.activate("..")
using Revise, TwoDots

using Gtk, Gtk.ShortNames

style_file = joinpath(dirname(Base.source_path()), "style.css")
provider = CssProviderLeaf(filename = style_file)


#provider = CssProviderLeaf(data="#green_button {color:blue;}")


w = Window("")
button = GtkButton("")
set_gtk_property!(button, :name, "green_button")
push!(w, button)
screen = Gtk.GAccessor.style_context(button)
push!(screen, StyleProvider(provider), 600)
Gtk.showall(w)



win = Window("Test")
lbl = Label("Some text")

sc = Gtk.GAccessor.style_context(lbl)
pr = CssProviderLeaf(data="#blue_text {color:blue;}")
push!(sc, StyleProvider(pr), 600)

set_gtk_property!(lbl, :name, "blue_text")

push!(win, lbl)
showall(win)

