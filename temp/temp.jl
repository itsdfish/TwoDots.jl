using Pkg 
cd(@__DIR__)
Pkg.activate("..")
using Revise, TwoDots

using Gtk.ShortNames

style_file = joinpath(dirname(Base.source_path()), "style.css")
provider = CssProviderLeaf(filename = style_file)

w = Window("CSS Test")

nb = Notebook()
screen = Gtk.GAccessor.style_context(nb)
push!(screen, StyleProvider(provider), 600)

f1 = Frame()
set_gtk_property!(f1, :name, "frame1")
screen = Gtk.GAccessor.style_context(f1)
push!(screen, StyleProvider(provider), 600)

f2 = Frame()
set_gtk_property!(f2, :name, "frame2")
screen = Gtk.GAccessor.style_context(f2)
push!(screen, StyleProvider(provider), 600)

f3 = Frame()
f4 = Frame()

push!(nb, f1, "Tab 1")
push!(nb, f2, "Tab 2")
push!(nb, f3, "Tab 3")
push!(nb, f4, "Tab 4")

push!(w, nb)

Gtk.showall(w)