proc _chat(@player, @message) {
	_irc_msg(@player . ': ' . @message);
	console("[Chat] @player: @message", false);

	@format = associative_array(
		'type': 'chat',
		'player': @player,
		'message': @message,
	);
	foreach(@player in all_players()) {
		tmsg(@player, _chatformat_construct_message(@player, @format));
	}
}

proc _chat_action(@player, @message) {
	_irc_msg('* ' . @player . ' ' . @message);
	console("[Chat] * @player @message", false);
	@format = associative_array(
		'type': 'action',
		'player': @player,
		'message': @message,
	);
	foreach(@player in all_players()) {
		tmsg(@player, _chatformat_construct_message(@player, @format));
	}
}

proc _chat_irc(@player, @message) {
	console("[IRC] @player: @message", false);
	@format = associative_array(
		'type': 'irc',
		'player': @player,
		'message': irc_irc2mc_colors(@message),
	);
	foreach(@player in all_players()) {
		tmsg(@player, _chatformat_construct_message(@player, @format));
	}
}

proc _chat_irc_action(@player, @message) {
	console("[IRC] * @player @message", false);
	@format = associative_array(
		'type': 'irc_action',
		'player': @player,
		'message': irc_irc2mc_colors(@message),
	);
	foreach(@player in all_players()) {
		tmsg(@player, _chatformat_construct_message(@player, @format));
	}
}

proc _colorize(@text, @colorArray) {
	console(@text);
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
