bind(player_chat, null, null, @event) {
	cancel();
	_chat(@event['player'], @event['message']);
}
