foreach(@player in all_players()) {
	_chatformat_cache_settings();
}

bind(player_join, associative_array('priority': 'high'), null, @event) {
	_chatformat_cache_settings(@event['player']);
}

_chatformat_get_options()

# Using alias format for now, as this is buggy.
/*
register_command('format', array(
	'description': 'Used to change various formats.',
	'usage': '/format <type> <format>',
	'permission': 'command.format',
	'executor': closure(@alias, @sender, @args, @info) {
		console(@alias)
		console(@sender)
		console(@args)
		console(@info)
	}
))

register_command('wow', array(
	'description': 'Used to change various formats.',
	'usage': '/format <type> <format>',
	'permission': 'command.format',
	'executor': closure(@alias, @sender, @args, @info) {
		console(@alias)
		console(@sender)
		console(@args)
		console(@info)
	}
))

register_command('timer', array(
	'description': 'Handles time trials for speed runs.',
	'usage': '/timer <start|stop> <id> <player>',
	'permission': 'command.timer',
	'executor': closure(@alias, @sender, @args, @info) {
		console(@alias)
		console(@sender)
		console(@args)
		console(@info)
	}
))
*/
