$fn = 30;

base_depth = 1.5;
wall_thickness = 2;

ont_width = 80; // 611B/D
// ont_width = 90; // 611Q
ont_height = 80;

ont_screw_mount = 50;
ont_screw_width = 10;
ont_screw_height = 20;
ont_screw_pos_y = 35;
ont_screw_round = 2;

ont_feet_d = 10;
ont_feet_margin = 5;

ups_width = 99;
ups_depth = 109;
ups_height = 25;
ups_padding = 1;

ups_left_tray_height = 30;
ups_left_tray_width = 15;
ups_right_tray_height = 30;
ups_right_tray_width = 30;
ups_side_tray_height = 15;

gap = 30;

module ont_base() {
	linear_extrude(base_depth)
	difference() {
		// base
		offset(wall_thickness) offset(-wall_thickness)
		square([ont_width, ont_height]);
		
		// feet
		translate([ont_feet_margin + ont_feet_d / 2, ont_feet_margin + ont_feet_d / 2])
		circle(d = ont_feet_d);

		translate([ont_width - ont_feet_margin - ont_feet_d / 2, ont_feet_margin + ont_feet_d / 2])
		circle(d = ont_feet_d);

		translate([ont_width - ont_feet_margin - ont_feet_d / 2, ont_height - ont_feet_margin - ont_feet_d / 2])
		circle(d = ont_feet_d);
		
		translate([ont_feet_margin + ont_feet_d / 2, ont_height - ont_feet_margin - ont_feet_d / 2])
		circle(d = ont_feet_d);
		
		// screw holes
		offset(ont_screw_round) offset(-ont_screw_round)
		translate([ont_width / 2 - ont_screw_width / 2 - ont_screw_mount / 2, ont_height - (ont_screw_pos_y + ont_screw_height / 2)])
		square([ont_screw_width, ont_screw_height]);

		offset(ont_screw_round) offset(-ont_screw_round)
		translate([ont_width / 2 - ont_screw_width / 2 + ont_screw_mount / 2, ont_height - (ont_screw_pos_y + ont_screw_height / 2)])
		square([ont_screw_width, ont_screw_height]);
	};
}

module ups_base() {
	difference() {
		// container
		linear_extrude(base_depth + ups_height +  ups_padding + wall_thickness)
		offset(wall_thickness) offset(-wall_thickness)
		square([ups_width + 2 * wall_thickness + ups_padding, ups_depth + 2 * 
	wall_thickness + ups_padding]);

		// cut ups out
		translate([0, 0, base_depth])
		linear_extrude(ups_height + ups_padding)
		translate([wall_thickness, wall_thickness])
		square([ups_width + ups_padding, ups_depth + ups_padding]);
		
		// cut top off
		translate([-1, wall_thickness + ups_side_tray_height, base_depth])
		linear_extrude(ups_height + ups_padding + wall_thickness + 1)
		square([ups_width + ups_padding + 2 * wall_thickness + 2, ups_depth - ups_side_tray_height + ups_padding + 2 * wall_thickness + 1]);
		
		// cut front out
		translate([wall_thickness, wall_thickness, base_depth])
		linear_extrude(ups_height + ups_padding + wall_thickness + 1)
		square([ups_width + ups_padding, ups_side_tray_height + 1]);
	}

	// left tray
	translate([0, 0, base_depth + ups_height + ups_padding])
	linear_extrude(wall_thickness)
	offset(wall_thickness) offset(-wall_thickness)
	square([wall_thickness + ups_left_tray_width, wall_thickness + ups_left_tray_height]);

	// right tray
	translate([wall_thickness + ups_width + ups_padding- ups_right_tray_width, 0, base_depth + ups_height + ups_padding])
	linear_extrude(wall_thickness)
	offset(wall_thickness) offset(-wall_thickness)
	square([wall_thickness + ups_right_tray_width, wall_thickness + ups_right_tray_height]);
}

module connector() {
	linear_extrude(base_depth)
	square([gap + wall_thickness, ont_height]);
}

translate([ups_width + ups_padding + 2 * wall_thickness, (ups_depth + ups_padding) / 2 - ont_height / 2, 0]) {
	translate([gap, 0, 0]) ont_base();
	connector();
}
ups_base();