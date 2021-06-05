using Pkg 
cd(@__DIR__)
Pkg.activate("..")
using Revise, TwoDots

using Gtk, Gtk.ShortNames

style_file = joinpath(dirname(Base.source_path()), "style.css")
provider = CssProviderLeaf(filename = style_file)


#provider = CssProviderLeaf(data="#green_button {color:blue;}")

using Gtk, Gtk.ShortNames
w = Window("")
button = GtkButton("")
sc = Gtk.GAccessor.style_context(button)
pr = CssProviderLeaf(data="#green_button {color:green;}")
push!(sc, StyleProvider(pr), 600)
set_gtk_property!(button, :name, "green_button")
push!(w, button)
Gtk.showall(w)


using Gtk, Gtk.ShortNames
win = Window("Test")
label = Label("Some text")
sc = Gtk.GAccessor.style_context(label)
pr = CssProviderLeaf(data="#blue_text {color:blue;}")
push!(sc, StyleProvider(pr), 600)
set_gtk_property!(label, :name, "blue_text")
push!(win, label)
showall(win)

