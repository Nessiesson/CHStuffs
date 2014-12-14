proc _irc_msg(@message) {
	@options = import('ircbot.options');
	@id = @options['id'];
	@message = irc_mc2irc_colors(colorize(@message));
	
	foreach(@channel in @options['channels']) {
		irc_msg(@options['id'], @channel, @message);
	}
}
