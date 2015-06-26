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

proc _colorize(@text, @colorArray) {
	@message = array();
	if(is_array(@colorArray)) {
		foreach(@char in @text) {
			@message[] = color(array_rand(@colorArray, 1, false)[0]) . @char;
		}
	} else {
		foreach(@char in @text) {
			@message[] = color(rand(0, 16)) . @char;
		}
	}
	@message = array_implode(@message, "");
	return(@message);
}

proc _last_color(@string) {
	@string = colorize(@string);
	@color = "";
	for(@i = length(@string) - 1, @i >= 0, @i--) {
		if(@string[@i] == "\u00A7") {
			if(reg_match("(?i)[0-9a-fklmnor]", @string[@i + 1])) {
				@color = "&" . @string[@i + 1] . @color;
			}
			if(reg_match("(?i)[0-9a-fr]", @string[@i + 1])) {
				return(@color);
			}
		}
	}
	return("&f");
}
 

proc _start() {
	export("profiling.start", nano_time());
}

proc _stop() {
	console("Took " . sprintf("%.3f", (nano_time() - import("profiling.start")) * double("1E-6")) . "ms.");
}

proc _log(@message, @package = "Log") {
	console(colorize("[@package] @message"), false);
}

proc _assert_length(@string, @length) {
	@stringLength = length(@string);
	if(@stringLength == @length) {
		return(true);
	} else {
		_log("Received string of length @stringLength. Expected length @length.");
		return(false);
	}
}

proc _is_char(@string) {
	return(_assert_length(@string, 1));
}

proc _is_char_uppercase(@char) {
	if(_is_char(@char)) {
		return(reg_count("[A-Z]", @char) == 1);
	} else {
		return(false);
	}
}

proc _is_char_lowercase(@char) {
	if(_is_char(@char)) {
		return(reg_count("[a-z]", @char) == 1);
	} else {
		return(false);
	}
}
