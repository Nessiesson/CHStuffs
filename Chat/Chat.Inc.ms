proc _colorize(@text, @colorArray) {
	@message = array();
	if(is_array(@colorArray)) {
		foreach(@char in @text) {
			@message[] = color(array_rand(@colorArray, 1, false)[0]) . @char;
		}
	} else {
		foreach(@char in @text) {
			@message[] = color(rand(0, 15)) . @char;
		}
	}
	@message = array_implode(@message, '');
	return(@message);
}
