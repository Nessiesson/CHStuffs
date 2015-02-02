_specialitems_reload();

bind('inventory_click', null, null, @event) {
	@specialsById = import('specialitems.byid');
	@id = _specialitems_get_id(@event['slotitem']);
	if(!is_null(@id)) {
		if(array_index_exists(@specialsById, @id)) {
			if(!@specialsById[@id]['clickable']) {
				cancel();
				die();
			}
		}
	}
	@id = _specialitems_get_id(@event['cursoritem']);
	if(!is_null(@id)) {
		if(array_index_exists(@specialsById, @id)) {
			if(!@specialsById[@id]['clickable']) {
				cancel();
			}
		}
	}
}

bind('item_drop', null, null, @event) {
	@specialsById = import('specialitems.byid');
	@id = _specialitems_get_id(@event['item']);
	if(!is_null(@id)) {
		if(array_index_exists(@specialsById, @id)) {
			if(!@specialsById[@id]['dropable']) {
				cancel();
			}
		}
	}
}

bind('player_death', null, null, @event) {
	@specialsById = import('specialitems.byid');
	@drops = @event['drops'];
	@modifyInventory = false;
	if(!is_null(@drops)) {
		foreach(@key: @data in @drops) {
			@id = _specialitems_get_id(@data);
			if(@id) {
				if(array_index_exists(@specialsById, @id)) {
					if(!@specialsById[@id]['dropondeath']) {
						array_remove(@drops, @key);
						@modifyInventory = true;
					}
				}
			}
		}
		if(@modifyInventory) {
			modify_event('drops', @drops);
		}
	}
}
