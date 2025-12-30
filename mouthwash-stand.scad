width = 90;
wedge_depth = 105;
base_depth = 370;
height = 143;

//base_thickness = 2;
base_thickness = 0;
wedge_thickness = 3;

module base(width, depth, thickness) {
	cube([width, depth, thickness]);
}

module wedge(width, depth, height) {
	polyhedron([
		// 0: back right
		[0, 0, 0],
		// 1: back left
		[width, 0, 0],
	
		// 2: front right
		[0, depth, 0],
		// 3: front left
		[width, depth, 0],

		// 4: top right
		[0, 0, height],
		// 5: top left
		[width, 0, height],
	], [
		[0, 1, 3, 2], // base
		[0, 4, 5, 1], // back
		[2, 3, 5, 4], // slope
		[1, 5, 3], // left side
		[0, 2, 4], // right side
	]);
}

module hollow_wedge(width, depth,
		height, thickness) {
	inner_width = width - 2 * thickness;
	inner_depth = depth - 3 * thickness;
	inner_height = height - 4 * thickness;

	difference() {
		wedge(width, depth, height);

		* translate([thickness,
			thickness, thickness])
		wedge((inner_width - thickness) / 2,
			inner_depth,
			inner_height);

		* translate([1.5 * thickness + inner_width / 2,
			thickness, thickness])
		wedge((inner_width - thickness) / 2,
			inner_depth,
			inner_height);
	}
}

if (base_thickness > 0) base(width, base_depth, base_thickness
);
hollow_wedge(width, wedge_depth, height, wedge_thickness);
