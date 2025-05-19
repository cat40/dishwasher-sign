include <scad-common/scad-common.scad>

text_size = 10;
text_depth = 1.5;
middle_thickness = 1 + max(2*(m6_magnet_thickness-text_depth), 0);
width = 60;
height = 35;
border_thickness = m6_magnet_diameter+1.2;

module dishwasher_sign()
{
    middle();
    text_3d("Clean", do_mirror=true);
    translate([0, 0, text_depth+middle_thickness])
        text_3d("Dirty");
    color("green")
        border();
    translate([0, 0, text_depth+middle_thickness])
        color("red")
            border();
}

module middle()
{
    translate([-width/2, 0, text_depth])
        cube([width, height, middle_thickness]);
}

module border()
{
    translate([0, height/2, 0])
    linear_extrude(text_depth)
    {
        difference()
        {
            square([width, height], center=true);
            square([width-2*border_thickness, height-2*border_thickness], center=true);
        }
    }
}

module text_3d(string, do_mirror=false)
{
    translate([0, height/2-text_size/2, 0])
        color("blue")
            linear_extrude(text_depth)
                if(do_mirror)
                {
                    mirror([1, 0, 0])
                        text(string, size=text_size, font="FreeSans", halign="center");
                }
                else
                {
                    text(string, size=text_size, font="FreeSans", halign="center");
                }
}

dishwasher_sign();