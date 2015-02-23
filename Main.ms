bind(player_command, null, null, @event) {
	@replacement = reg_replace("^/\\S*:", "/", @event["command"]);
	modify_event("command", @replacement);
}

bind(player_join, null, null, @event) {
	scriptas(@event["player"], sudo("/interpreter"));
}
