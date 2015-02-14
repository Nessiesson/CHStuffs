_uuid_reload();

bind(player_login, null, null, @event) {
	@uuid = _uuid(@event["uuid"]);
	_uuid_reload_player(@uuid);
	_uuid_set_names(@uuid);
}
