/**
 * Given two blocks, iterates through all the blocks inside the cuboid, and calls the
 * user defined function on them. The used defined procedure should accept 3 parameters,
 * the x, y, and z coordinates of the block.
 */

proc _iterate_cuboid(@b1, @b2, @proc_name) {
	for(@x = min(@b1[0], @b2[0]), @x <= max(@b1[0], @b2[0]), @x++) {
		for(@y = min(@b1[1], @b2[1]), @y <= max(@b1[1], @b2[1]), @y++) {
			for(@z = min(@b1[2], @b2[2]), @z <= max(@b1[2], @b2[2]), @z++) {
				call_proc(@proc_name, @x, @y, @z);
			}
		}
	}
}

/**
 * Returns the distance between two blocks, or any other 2d points, for that matter.
 * @param array @b1 The first point, expects an array of x, y
 * @param array @b2 The second point, expects an array of x, y
 */
proc _2d_distance(@b1, @b2) {
	return(
		floor(
			sqrt(
				((@b2[0] - @b1[0]) ** 2) +
				((@b2[1] - @b1[1]) ** 2)
			)
		)
	);
}

/**
 * Returns the distance between two blocks, or any other 3d points, for that matter.
 * @param array @b1 The first point, expects an array of x, y, z
 * @param array @b2 The second point, expects an array of x, y, z
 */
proc _3d_distance(@b1, @b2) {
	return(
		floor(
			sqrt(
				((@b2[0] - @b1[0]) ** 2) +
				((@b2[1] - @b1[1]) ** 2) + 
				((@b2[2] - @b1[2]) ** 2)
			)
		)
	);
}

include('ActionBar.Inc.ms');
include('MinecraftVersion.Inc.ms');
