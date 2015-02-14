proc _uuid_reload() {
	foreach(@player in all_players()) {
		_uuid_reload_player(@player);
	}
}

proc _uuid_reload_player(@player) {
	@uuid = _uuid(@player);
	if(is_null(get_value("uuid.@uuid.names.short"))) {
		@full = array(associative_array(
			name: player(@uuid),
		));
		@short = array(
			player(@uuid),
		);
		store_value("uuid.@uuid.names.full", @full);
		store_value("uuid.@uuid.names.short", @short);
	}
	export("uuid.@uuid.names.full", get_value("uuid.@uuid.names.full"));
	export("uuid.@uuid.names.short", get_value("uuid.@uuid.names.short"));
}

proc _uuid(@player) {
	@length = length(@player);
	@uuid = "";
	if(@length <= 16) {
		if(ponline(@player)) {
			@uuid = replace(pinfo(@player, 20), "-", "");
		} else {
			_log("Name -> UUID from offline players is currently not supported.", "UUID");
			throw("PlayerOfflineException", "The user \"@player\" is currently not online.");
		}
	} else if(@length == 32) {
		@uuid = @player;
	} else if(@length == 36) {
		@uuid = replace(@player, "-", "");
	} else {
		_log("Invalid playername/UUID: \"@player\".", "UUID");
		throw("RangeException", "Unknown name-length.");
	}
	return(@uuid);
}

proc _uuid_dashes(@player) {
	@uuid = _uuid(@player);
	@uuidDashes = substr(@uuid, 0, 8) . "_";
	@uuidDashes .= substr(@uuid, 8, 12) . "_";
	@uuidDashes .= substr(@uuid, 12, 16) . "_";
	@uuidDashes .= substr(@uuid, 16, 20) . "_";
	@uuidDashes .= substr(@uuid, 20, 32);
	return(@uuidDashes);
}

proc _uuid_set_names(@player) {
	@uuid = _uuid(@player);
	@options = associative_array(
		success: closure(@response) {
			if(@response["responseCode"] == 200) {
				@uuids = json_decode(@response["body"]);
				@short = array();
				foreach(@entry in @uuids) {
					@short[] = @entry["name"];
				}
				store_value("uuid.@uuid.names.full", @uuids);
				store_value("uuid.@uuid.names.short", @short);
			} else {
				_log("Failed to retrieve UUID: @uuid", "UUID");
			}
		},
		error: closure(@response) {
			_log("Failed to retrieve UUID: @uuid", "UUID");
		}
	);
	http_request("https://api.mojang.com/user/profiles/@uuid/names", @options);
}

proc _uuid_get_names_full(@player) {
	@uuid = _uuid(@player);
	return(import("uuid.@uuid.names.full"));
}

proc _uuid_get_names_short(@player) {
	@uuid = _uuid(@player);
	return(import("uuid.@uuid.names.short"));
}
