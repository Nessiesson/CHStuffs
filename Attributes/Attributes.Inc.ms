proc _attributes_register_attribute(@attribute = "") {
	if(@attribute == "") {
		_log("Attempted to register attribute with no name.", "Attributes");
	}
	@attributes = import("attributes");
	if(!is_array(@attributes)) {
		@attributes = array();
	}
	if(array_contains(@attributes, @attribute)) {
		_log("Attribute @attribute already exists.", "Attributes");
	}
	@attributes[] = @attribute;
	export("attributes", @attributes);
}

proc _attributes_attribute_exists(@attribute) {
	@attributes = import("attributes");
	return(array_contains(@attributes, @attribute));
}

proc _attributes_all_attributes() {
	return(import("attributes"));
}

proc _attributes_item_has_attribute(@item, @attribute) {
	if(_inventory_lore_exists(@item)) {
		foreach(@line in @item["meta"]["lore"]) {
			if(string_position(@line, colorize("&d&e@attribute&r")) > -1) {
				return(true);
			}
		}
	}
	return(false);
}

proc _attributes_item_has_any_attribute(@item) {
	@attributes = import("attributes");
	foreach(@attribute in @attributes) {
		if(_attributes_item_has_attribute(@item, @attribute)) {
			return(true);
		}
	}
	return(false);
}

proc _attributes_get_attributes_from_item(@item) {
	@attributes = import("attributes");
	@itemAttributes = array();
	foreach(@attribute in @attributes) {
		if(_attributes_item_has_attribute(@item, @attribute)) {
			@itemAttributes[] = @attribute;
		}
	}
	return(@itemAttributes);
}

proc _attributes_item_add_attribute(@item, @attribute) {
	if(!_attributes_attribute_exists(@attribute)
	|| _attributes_item_has_attribute(@item, @attribute)) {
		return(@item);
	}
	if(!is_array(@item["meta"])) {
		@item["meta"] = associative_array();
		@item["meta"]["lore"] = array();
	}
	@item["meta"]["lore"][] = colorize("&d&e@attribute&r");
	return(@item);
}

proc _attributes_item_add_attribute_to_slot(@player, @attribute, @slot = "") {
	if(@slot == "") {
		@slot = pinfo(@player, 15);
	}
	@item = pinv(@player, @slot);
	if(is_null(@item)) {
		return(false);
	}
	@inv = associative_array();
	@inv[@slot] = _attributes_item_add_attribute(@item, @attribute);
	if(is_null(@inv[@slot])) {
		return(false);
	}
	set_pinv(@player, @inv);
	return(true);
}

proc _attributes_item_remove_attribute(@item, @attribute) {
	if(!_attributes_item_has_attribute(@item, @attribute)) {
		return(@item);
	}
	@lore = @item["meta"]["lore"];
	@item["meta"]["lore"] = array();
	foreach(@line in @lore) {
		@line = replace(@line, colorize("&d&e@attribute&r"), "");
		if(@line != "") {
			@item["meta"]["lore"][] = @line;
		}
	}
	return(@item);
}

proc _attributes_item_remove_attribute_from_slot(@player, @attribute, @slot = "") {
	if(@slot == "") {
		@slot = pinfo(@player)[15];
	}
	@item = pinv(@player)[@slot];
	if(is_null(@item)) {
		return(false);
	}
	@inv = associative_array();
	@inv[@slot] = _attributes_item_remove_attribute(@item, @attribute);
	if(@inv[@slot] == @item) {
		return(false);
	}
	set_pinv(@player, @inv);
	return(true);
}

proc _attributes_has_item_with_attribute(@player, @attribute, @inv) {
	if(@inv == "") {
		@inv = pinv(@player);
	}
	foreach(@slot: @item in @inv) {
		if(is_null(@item)) {
			continue();
		}
		if(_attributes_item_has_attribute(@item, @attribute)) {
			return(true);
		}
	}
	return(false);
}

proc _attributes_remove_items_with_attribute(@player, @attribute) {
	@inv = pinv(@player);
	foreach(@slot: @item in @inv) {
		if(is_null(@slot)) {
			continue();
		}
		if(_attributes_item_has_attribute(@item, @attribute)) {
			@inv[@slot] = null;
		}
	}
	set_pinv(@player, @inv);
	return(true);
}
