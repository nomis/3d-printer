$fn = 30;

base_depth = 1.4;
wall_thickness = 2;
margin_top = 5;

ont_width = 109.9;
ont_height = 108.8 - margin_top;

ont_screw_mount = 60;
ont_screw_width = 23;
ont_screw_height = 22;
ont_screw_pos_y = 52 - margin_top;
ont_screw_round = 2;

ont_feet_d = 11;
ont_feet_margin_t = 15 - margin_top;
ont_feet_margin_b = 9;
ont_feet_margin_lr = 7.5;

ups_width = 99;
ups_depth = 109;
ups_height = 25;
ups_padding = 2;

ups_tray_height = 70;

gap = 25;
offset = 0;

module ont_base() {
	difference() {
		linear_extrude(base_depth)
		difference() {
			// base
			offset(wall_thickness) offset(-wall_thickness)
			square([ont_width, ont_height]);
			
			// feet
			translate([ont_feet_margin_lr + ont_feet_d / 2, ont_feet_margin_b + ont_feet_d / 2])
			circle(d = ont_feet_d);

			translate([ont_width - ont_feet_margin_lr - ont_feet_d / 2, ont_feet_margin_b + ont_feet_d / 2])
			circle(d = ont_feet_d);

			translate([ont_width - ont_feet_margin_lr - ont_feet_d / 2, ont_height - ont_feet_margin_t - ont_feet_d / 2])
			circle(d = ont_feet_d);
			
			translate([ont_feet_margin_lr + ont_feet_d / 2, ont_height - ont_feet_margin_t - ont_feet_d / 2])
			circle(d = ont_feet_d);
			
			// screw holes
			offset(ont_screw_round) offset(-ont_screw_round)
			translate([ont_width / 2 - ont_screw_width / 2 - ont_screw_mount / 2, ont_height - (ont_screw_pos_y + ont_screw_height / 2)])
			square([ont_screw_width, ont_screw_height]);

			offset(ont_screw_round) offset(-ont_screw_round)
			translate([ont_width / 2 - ont_screw_width / 2 + ont_screw_mount / 2, ont_height - (ont_screw_pos_y + ont_screw_height / 2)])
			square([ont_screw_width, ont_screw_height]);
		};
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
		translate([-1, wall_thickness + ups_tray_height, base_depth])
		linear_extrude(ups_height + ups_padding + wall_thickness + 1)
		square([ups_width + ups_padding + 2 * wall_thickness + 2, ups_depth - ups_tray_height + ups_padding + 2 * wall_thickness + 1]);
	}

	// tray
	translate([0, 0, base_depth + ups_height + ups_padding])
	linear_extrude(wall_thickness)
	offset(wall_thickness) offset(-wall_thickness)
	square([wall_thickness + ups_width + ups_padding + wall_thickness, wall_thickness + ups_tray_height]);
}

module connector() {
	linear_extrude(base_depth)
	offset(wall_thickness) offset(-wall_thickness)
	square([ups_width + ups_padding + 2 * wall_thickness, ont_height]);

	linear_extrude(base_depth)
	translate([ups_width + ups_padding + wall_thickness, 0])
	square([gap + wall_thickness, ont_height]);

}

translate([ups_width + ups_padding + wall_thickness, offset, 0]) {
	translate([gap, 0, 0]) ont_base();

	translate([- ups_width - ups_padding - wall_thickness, 0, 0])
	connector();
}
ups_base();
