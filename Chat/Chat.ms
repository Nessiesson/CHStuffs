bind(async_player_chat, null, null, @event) {
	cancel();
	@player = @event["player"];
	@pastNames = _uuid_get_names_short(@player)[..-2];
	@name = associative_array(
		text: @player,
		suggest_command: "/msg @player ",
	);
	if(array_size(@pastNames) > 0) {
		@name["show_text"] = "&o@player was previously known as:\n" . array_implode(@pastNames, "\n");
	}
	@tellraw = array(@name);
	@tellraw[] = associative_array(
		text: ": " . @event["message"];
	);
	_tellraw_broadcast(@tellraw);
}
