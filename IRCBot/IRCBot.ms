@options = associative_array(
	server: 'irc.irchighway.net',
	port: 6667,
	username: 'nessei',
	realname: 'nessie',
	password: 'lol',
	id: 0,
	channels: array(
		'#logiz', #@TODO: Move this to a config file.
	),
	connect: true,
);
export('ircbot.options', @options);

if(@options['connect']) {
	irc_create(@options['id']);
	irc_connect(@options['id'], @options['username'], @options['server'], @options);
	
	bind(irc_welcomed, null, null, @event, @options) {
		foreach(@channel in @options['channels']) {
			irc_join(@options['id'], @channel);
		}
		@message = 'Joined channel';
		if(array_size(@options['channels']) > 1) {
			@message .= 's';
		}
		console("@message: " . array_implode(@options['channels'], ', '));
	}
	
	bind(irc_msg, null, null, @event) {
		_chat_irc(@event['who'], @event['message']);
	}

	bind(irc_action, null, null, @event) {
		_chat_irc_action(@event['who'], @event['message']);
	}
}
