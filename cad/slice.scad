use </home/user/sprut.korpus/cad/sprut_korpus.scad>
which = "box";   // box | bezel | mon | pi | cards
axis  = "y";     // y: разрез плоскостью Y=pos ; x: плоскостью X=pos
pos   = 76.7;
module sel() {
  if (which == "box")   box();
  if (which == "bezel") bezel_world();
  if (which == "mon")   ghost_monitor();
  if (which == "pi")    ghost_pi();
  if (which == "cards") ghost_cards();
  if (which == "plugs") ghost_plugs();
}
// результат: 2D, X = координата вдоль разреза, Y = глубина Z корпуса
if (axis == "y") projection(cut=true) rotate([-90, 0, 0]) translate([0, -pos, 0]) sel();
else             projection(cut=true) rotate([-90, 0, 0]) rotate([0, 0, -90]) translate([-pos, 0, 0]) sel();
