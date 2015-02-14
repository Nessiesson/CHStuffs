bind(player_command, null, null, @event) {
	_start();
	@replacement = reg_replace("\\/(.*):(.*?)", "/", @event["command"]);
	console(@replacement);
	modify_event("command", @replacement);
	_stop();
}

bind(player_join, null, null, @event) {
	scriptas(@event["player"], sudo("/interpreter"));
}
