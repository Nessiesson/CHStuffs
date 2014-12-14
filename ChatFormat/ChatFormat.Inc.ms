proc _chatformat_get_options() {
	@options = associative_array(
		'chat': 'Customise the format of the chat',
		'join': 'Customise the format of players joining',
		'leave': 'Customise the format of players leaving',
		'action': 'Customise the format of actions',
		'pm': 'Customise the format of private messages',
		'irc': 'Customise the format of IRC messages',
		'irc_action': 'Customise the format of IRC actions',
	);
	return(@options);
}

proc _chatformat_default_format(@type) {
	if(!array_index_exists(_chatformat_get_options(), @type)) {
		return('');
	}
	@options = associative_array(
		'chat': '%player%: %message%',
		'join': '&e%player% has joined.',
		'leave': '&e%player% has left.',
		'action': '* %player% %message%',
		'pm': '%from%->%to%: %message%',
		'irc': '[IRC] %player%: %message%',
		'irc_action': '[IRC] * %player% %message%',
	);
	if(!array_index_exists(@options, @type)) {
		return(array(''));
	}
	return(@options[@type]);

}

proc _chatformat_get_format(@player, @type) {
	@options = import('chatformat.format.' . @player);
	if(!is_array(@options)
	|| !array_index_exists(@options, @type)) {
		@options = get_value('chatformat.format.' . @player);
	}
	@options = get_value('chatformat.format.' . @player);

	if(!is_array(@options)
	|| !array_index_exists(@options, @type)) {
		return(_chatformat_default_format(@type))
	}
	return(@options[@type]);
}

proc _chatformat_set_format(@player, @type, @message) {
	@options = get_value('chatformat.format.' . @player);
	if(!is_array(@options)) {
		@options = associative_array();
	}
	@options[@type] = @message;
	store_value('chatformat.format.' . @player, @options);
	_chatformat_cache_settings();
}

proc _chatformat_construct_message(@player, @info) {
	@message = _chatformat_get_format(@player, @info['type']);

	if(array_index_exists(@info, 'player')) {
		@message = replace(@message, '%player%', @info['player']);
	}
	if(array_index_exists(@info, 'message')) {
		@message = replace(@message, '%message%', @info['message']);
	}
	if(array_index_exists(@info, 'from')) {
		@message = replace(@message, '%from%', @info['from']);
	}
	if(array_index_exists(@info, 'to')) {
		@message = replace(@message, '%to%', @info['to']);
	}

	return(colorize(@message));
}

proc _chatformat_cache_settings(@player) {
	@options = get_value('chatformat.format.' . @player);
	if(!is_array(@options)) {
		return();
	}
	export('chatformat.format.' . @player, @options);
}
