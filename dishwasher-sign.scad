include <scad-common/scad-common.scad>

text_size = 30;
text_depth = 1.5;
middle_thickness = 1 + max(2*(m6_magnet_thickness-text_depth), 0);
width = 120;
height = 65;
corner_radius=5;
//magnet_spacing = 30;
magnet_spacing = 60;
magnet_distance_from_edge = 1.2;

// derived variables
x_magnet_count=floor((width-magnet_distance_from_edge-m6_magnet_diameter/2)/magnet_spacing);
x_magnet_spacing=(width-2*magnet_distance_from_edge-m6_magnet_diameter)/x_magnet_count;
y_magnet_count=floor((height-magnet_distance_from_edge-m6_magnet_diameter/2)/magnet_spacing);
y_magnet_spacing=(height-2*magnet_distance_from_edge-m6_magnet_diameter)/y_magnet_count;
border_thickness = m6_magnet_diameter+magnet_distance_from_edge;

module dishwasher_sign()
{
    difference()
    {
        union()
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
        translate([-width/2, 0, 0])
            #magnets();
    }
}

module magnets()
{
    translate([(magnet_distance_from_edge+m6_magnet_diameter/2), (magnet_distance_from_edge/2+m6_magnet_diameter/2), 0])
    {
        x_magnets();
        translate([0, height-1*magnet_distance_from_edge-m6_magnet_diameter, 0])
            x_magnets();
        y_magnets();
        translate([width-1*magnet_distance_from_edge-m6_magnet_diameter, 0, 0])
            y_magnets();
    }
}

module x_magnets()
{
    rectangle_array(x_magnet_count, 1, x_spacing=x_magnet_spacing, y_spacing=.1)
        m6_magnet();
}

module y_magnets()
{
    rectangle_array(1, y_magnet_count, y_spacing=y_magnet_spacing, x_spacing=.1)
        m6_magnet();
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
//magnets();