proc _reload_all_players() {
	foreach(@player in all_players()) {
		_reload_pdata(@player);
	}
}

proc _reload_pdata(@player) {
	@uuid = _uuid(@player);
	@pdata = _pdata(@uuid);
	if(!is_array(@pdata)
	|| !is_associative(@pdata)) {
		@pdata = associative_array(
			names: array(player(@uuid)),
		);
	}
	export("uuid.@uuid", @pdata);
}

proc _pdata(@player = "") {
	@uuid = _uuid(@player);
	@pdata = import("uuid.@uuid");
	return(@pdata);
}

proc _set_pdata(@player = "", @pdata) {
	@uuid = _uuid(@player);
	store_value("uuid.@uuid", @pdata);
	_reload_pdata(@uuid);
}

proc _uuid(@player = "") {
	if(@player == "") {
		try(@player = player());
	}
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

proc _uuid_dashes(@player = "") {
	@uuid = reg_replace("^(.{8})(.{4})(.{4})(.{4})(.{12})$", "$1-$2-$3-$4-$5", _uuid(@player));
	return(@uuid);
}

proc _uuid_set_names(@player = "") {
	console("..")
	@uuid = _uuid(@player);
	@options = associative_array(
		success: closure(@response) {
			if(@response["responseCode"] == 200) {
				@uuids = json_decode(@response["body"]);
				@names = array();
				console(@uuids)
				foreach(@name in @uuids) {
					@names[] = @name["name"];
				}
				@pdata = _pdata(@uuid);
				@pdata["names"] = @names;
				_set_pdata(@uuid, @pdata);
			} else {
				_log("Failed to retrieve UUID: @uuid.", "UUID");
			}
		},
		error: closure(@response) {
			_log("Failed to retrieve UUID: @uuid, code (" . @response["responseCode"] . ").", "UUID");
		}
	);
	http_request("https://api.mojang.com/user/profiles/@uuid/names", @options);
}

proc _uuid_get_names(@player = "") {
	@uuid = _uuid(@player);
	return(_pdata(@uuid)["names"]);
}

proc _all_players(@world = "") {
	@players = array();
	if(array_contains(get_worlds(), @world)) {
		@players = all_players(@world);
	} else {
		@players = all_players();
	}
	@uuids = array();
	foreach(@player in @players) {
		@uuids[] = _uuid(@player);
	}
	return(@uuids);
}
