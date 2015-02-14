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

proc _start() {
	export("profiling.start", nano_time());
}

proc _stop() {
	console("Took " . sprintf("%.3f", (nano_time() - import("profiling.start")) * double("1E-6")) . "ms.");
}

proc _log(@message, @package) {
	@pwd = @package;
	if(@package == "") {
		@pwd = "Log";
	}
	console(colorize("[@pwd] @message"), false);
}
