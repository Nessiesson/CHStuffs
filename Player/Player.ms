_uuid_reload();

bind(player_login, null, null, @event) {
	@uuid = _uuid(@event["uuid"]);
	_uuid_set_names(@uuid);
	set_timeout(0, closure() {
		_uuid_reload_player(@uuid);
	});
}
