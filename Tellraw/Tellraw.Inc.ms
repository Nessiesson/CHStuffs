/**
 * Given playername and message array, converts the message array to JSON and 
 * sends it to playername with the /tellraw command.
 * Examples are shown below in Tellraw.ms
 */

proc _tellraw(@player, @message) {
	if(!ponline(@player)) {
		return();
	}
	@json = associative_array(
		text: '',
		extra: array(),
	);
	if(is_array(@message)) {
		foreach(@element in @message) {
			@json['extra'][] = _construct_json(@element);
		}
	} else {
		tmsg(@player, colorize(@message));
		return();
	}
	@json = json_encode(@json);
	scriptas(@player, '*', sudo("/tellraw @player @json"));
}

proc _construct_json(@message) {
	@json = associative_array();
	if(array_index_exists(@message, 0)) {
		@json['text'] = colorize(@message[0]);
		@meta = _construct_json_meta(@message);
		@json = array_merge(@json, @meta);
	}
	return(@json);
}

proc _construct_json_meta(@message) {
	switch(@message[1]) {
		# The URL in open_url _must_ be prefixed by: http:// , else the MC client will crash.
		case 'open_url':
			@meta = _construct_json_click(@message);
		case 'run_command':
			@meta = _construct_json_click(@message);
			@meta['hoverEvent']['value'] = colorize('&eClick to run: &r' . @meta['hoverEvent']['value']);
		case 'suggest_command':
			@meta = _construct_json_click(@message);
		case 'show_text':
			@meta = _construct_json_hover(@message);
		default:
			@meta = associative_array();
	}
	return(@meta);
}

proc _construct_json_hover(@message) {
	@meta = associative_array();
	@meta['hoverEvent'] = associative_array();
	@meta['hoverEvent']['action'] = 'show_text';
	@meta['hoverEvent']['value'] = colorize(@message[2]);
	return(@meta);
}

proc _construct_json_click(@message) {
	@meta = associative_array();
	@meta['clickEvent'] = associative_array();
	@meta['clickEvent']['action'] = @message[1];
	@meta['clickEvent']['value'] = @message[2];
	@meta = array_merge(@meta, _construct_json_hover(@message));
	return(@meta);
}