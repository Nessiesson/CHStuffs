bind(player_chat, null, null, @event) {
	cancel();
	_chat(@event['player'], @event['message']);
}
# \\S{2,}\\.\\S{2,} to match URLs.
