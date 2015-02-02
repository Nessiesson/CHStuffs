proc _specialitems_reload() {
	@specials = get_value('specialitems');
	if(!is_array(@specials)) {
		@specials = associative_array();
	}
	@specialsById = associative_array();
	foreach(@key: @value in @specials) {
		@specialsById[@value['id']] = @value;
		@specialsById[@value['id']]['name'] = @key;
	}
	export('specialitems', @specials);
	export('specialitems.byid', @specialsById);
}

proc _specialitems_register(@special, @options) {
	@specials = get_value('specialitems');
	if(!is_array(@specials)) {
		@specials = associative_array();
	}
	if(array_index_exists(@specials, @special)) {
		return();
	}
	@id = get_value('specialitems.nextid');
	if(!is_integer(@id)) {
		@id = 0;
	}
	if(@id > 999) {
		console('[SpecialItems] Upper limit of 1000 special items has been reached. Aborting registration of \"' . @special . '\".', false);
		return();
	}
	@specials[@special] = associative_array(
		'id': @id,
		'clickable': true,
		'dropable': true,
		'dropondeath': false,
	);
	@id++;
	if(is_array(@options)) {
		foreach(@option: @value in @options) {
			@specials[@special][@option] = @value;
		}
	}
	store_value('specialitems.nextid', @id);
	store_value('specialitems', @specials);
	_specialitems_reload();
}

proc _specialitems_exists(@special) {
	@specials = import('specialitems');
	return(array_contains(@specials, @special));
}

proc _specialitems_get_id(@item) {
	if(_inventory_lore_exists(@item)) {
		if(array_index_exists(@item['meta']['lore'], 0)
		&& length(@item['meta']['lore'][0]) >= 10
		&& substr(@item['meta']['lore'][0], 0, 2) == colorize('&6')
		&& substr(@item['meta']['lore'][0], 8, 10) == colorize('&r')) {
			return(
				substr(@item['meta']['lore'][0], 3, 4) +
				substr(@item['meta']['lore'][0], 5, 6) +
				substr(@item['meta']['lore'][0], 7, 8)
			);
		}
	}
	return(null);
}

proc _specialitems_is_special(@special, @item) {
	@id = _specialitems_get_id(@item);
	if(is_null(@id)) {
		return(false);
	}
	@specialFromId = import('specialitems.byid')[@id];
	return(@specialFromId['name'] == @special);
}

proc _specialitems_make_special(@special, @item, @name) {
	@specials = import('specialitems');
	if(!array_index_exists(@specials, @special)) {
		console('[SpecialItems] Item \"' . @special . '\" doesn\'t exist.', false);
		die();
	}
	if(!is_array(@item)) {
		@item = associative_array();
	}
	if(!array_index_exists(@item, 'type')) {
		@item['type'] = 1;
	}
	if(!array_index_exists(@item, 'meta')) {
		@item['meta'] = associative_array();
	}
	if(!is_null(@name)) {
		@item['meta']['display'] = colorize(@name);
	}
	if(!array_index_exists(@item['meta'], 'lore')) {
		@item['meta']['lore'] = array();
	}
	@id = @specials[@special]['id'];
	switch(length(@id)) {
		case 1:
			@lore = '00' . @id;
		case 2:
			@lore = '0' . @id;
	}
	@lore = split('', @lore);
	@lore = array_implode(@lore, '&');
	@item['meta']['lore'][0] = colorize('&6&' . @lore . '&r');
	return(@item);
}

proc _specialitems_remove_specials(@special, @player) {
	@inv = pinv(@player);
	foreach(@key: @value in @inv) {
		if(_specialitems_is_special(@special, @value)) {
			@inv[@key] = null;
		}
	}
	set_pinv(@player, @inv);
	return(true);
}
