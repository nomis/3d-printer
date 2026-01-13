$fn = 30;

front_size = 87;
back_size = 86;
spacer_thickness = 3;
spacer_depth = 20;
spacer_rotate_deg = -2.25;

back_supports_depth = 3;
back_supports_border = 5;

back_screw_area_depth = 8;
back_screw_area_width = 15;
back_screw_area_height = 11;

front_screw_area_depth = 15;
front_screw_area_width = 15;
front_screw_area_height = 11;

back_screw_hole_diameter = 3.5;
front_screw_hole_diameter = 3.5;
screw_hole_distance = 60;

module base() {
	linear_extrude(spacer_depth, twist=spacer_rotate_deg, slices=spacer_depth / 0.2, scale=front_size/back_size)
	offset(1) offset(-1)
	difference() {
		square([back_size, back_size], center=true);
		square([back_size - 2 * spacer_thickness, back_size - 2 * spacer_thickness], center=true);
	}
}

module back_supports() {
	linear_extrude(back_supports_depth, twist=spacer_rotate_deg * (back_supports_depth / spacer_depth), slices=back_supports_depth / 0.2)
	difference() {
		square([back_size - 2 * spacer_thickness, back_size - 2 * spacer_thickness], center=true);
		square([back_size - 2 * (spacer_thickness + back_supports_border), back_size - 2 * (spacer_thickness + back_supports_border)], center=true);
	}
}

module screw_area(width, height, depth, rotate_deg) {
	linear_extrude(depth, twist=spacer_rotate_deg * (depth / spacer_depth), slices=depth / 0.2)
	rotate(rotate_deg)
	union() {
		translate([back_size / 2 - width / 2, 0])
		square([width - height / 2, height], center=true);
		
		translate([back_size / 2 - width / 2 - height / 2, 0])
		circle(d=height);

		translate([-(back_size / 2 - width / 2), 0])
		square([width - height / 2, height], center=true);
		
		translate([-(back_size / 2 - width / 2 - height / 2), 0])
		circle(d=height);
	}
}

module screw_holes(diameter, distance, rotate_deg) {
	linear_extrude(spacer_depth)
	rotate(rotate_deg)
	union() {
		translate([distance / 2, 0])
		circle(d=diameter);

		translate([-(distance / 2), 0])
		circle(d=diameter);
	}
}

base();
back_supports();
difference() {
	screw_area(back_screw_area_width, back_screw_area_height, back_screw_area_depth, 0);
	screw_holes(back_screw_hole_diameter, screw_hole_distance, 0);
}
difference() {
	screw_area(front_screw_area_width, front_screw_area_height, front_screw_area_depth, 90);
	screw_holes(front_screw_hole_diameter, screw_hole_distance, 90);
}
