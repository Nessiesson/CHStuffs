bind(player_chat, null, null, @event) {
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
		text: "&7:&r ",
	);
	@urlRegex = '(?i)(https?:\\/\\/)?[\\w-]+(\\.[\\w-]+)+\\.?(:\\d+)?(\\/\\S*)?';
	foreach(@word in parse_args(@event["message"])) {
		if(reg_count(@urlRegex, _strip_colors(@word)) > 0) {
			if(!_string_starts_with(to_lower(@word), "http://")) {
				@url = "http://@word";
			} else {
				@url = @word;
			}
			@tellraw[] = associative_array(
				text: "@word ",
				open_url: strip_colors(@url),
				show_text: "Click to open @word",
			);
		} else {
			@tellraw[] = associative_array(
				text: "@word ",
			);
		}
	}
	_tellraw_broadcast(@tellraw);
}
