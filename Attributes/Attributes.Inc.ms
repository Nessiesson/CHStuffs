proc _attributes_register_attribute(@attribute) {
	@attributes = import("attributes");
	if(!is_array(@attributes)) {
		@attributes = array();
	}
	if(array_contains(@attributes, @attribute)) {
		console("[Attributes] Attribute @attribute already exists.", false)
		return(false);
	}
	@attributes[] = @attribute;
	export("attributes", @attributes);
}

proc _attributes_attribute_exists(@attribute) {
	@attributes = import("attributes");
	@bool = array_contains(@attributes, @attribute);
	return(@bool);
}

proc _attributes_all_attributes() {
	return(import("attributes"));
}

proc _attributes_item_has_attribute(@attribute, @item) {
	if(_inventory_lore_exists(@item)) {
		foreach(@line in @item["meta"]["lore"]) {
			if(string_position(@line, colorize("&d&e @attribute&r")) > -1) {
				return(true);
			}
		}
	}
	return(false);
}

proc _attributes_item_has_any_attribute(@item) {
	@attributes = import("attributes");
	foreach(@attribute in @attributes) {
		if(_attributes_item_has_attribute(@attribute, @item)) {
			return(true);
		}
	}
	return(false);
}

proc _attributes_get_attributes_from_item(@item) {
	@attributes = import("attributes");
	@attributesOnItem = array();
	foreach(@attribute in @attributes) {
		if(_attributes_item_has_attribute(@attribute, @item)) {
			@attributesOnItem[] = @attribute;
		}
	}
	return(@attributesOnItem);
}

proc _attributes_item_add_attribute(@attribute, @item) {
	if(!_attributes_attribute_exists(@attribute)) {
		return(null);
	}
	if(_attributes_item_has_attribute(@attribute, @item)) {
		return(null);
	}
	if(!is_array(@item["meta"])) {
		@item["meta"] = associative_array();
		@item["meta"]["lore"] = array();
	}
	@item["meta"]["lore"][] = colorize("&d&e @attribute&r");
	return(@item);
}

proc _attributes_item_add_attribute_to_slot(@attribute, @player, @slot) {
	if(@slot == "") {
		@slot = pinfo(@player)[15];
	}
	@item = pinv(@player)[@slot];
	if(is_null(@item)) {
		return(false);
	}
	@inv = associative_array();
	@inv[@slot] = _attributes_item_add_attribute(@attribute, @item);
	if(is_null(@inv[@slot])) {
		return(false);
	}
	set_pinv(@player, @inv);
	return(true);
}

proc _attributes_item_remove_attribute(@attribute, @item) {
	if(!_attributes_item_has_attribute(@attribute, @item)) {
		return(null);
	}
	@lore = @item["meta"]["lore"];
	@item["meta"]["lore"] = array();
	foreach(@index: @line in @lore) {
		@line = replace(@line, colorize("&d&e @attribute&r"), "");
		if(@line != "") {
			@item["meta"]["lore"][] = @line;
		}
	}
	return(@item);
}

proc _attributes_item_remove_attribute_from_slot(@attribute, @player, @slot) {
	if(@slot == "") {
		@slot = pinfo(@player)[15];
	}
	@item = pinv(@player)[@slot];
	if(is_null(@item)) {
		return(false);
	}
	@inv = associative_array();
	@inv[@slot] = _attributes_item_remove_attribute(@attribute, @item);
	if(is_null(@inv[@slot])) {
		return(false);
	}
	set_pinv(@player, @inv);
	return(true);
}

proc _attributes_has_item_with_attribute(@attribute, @player, @inv) {
	if(@inv == "") {
		@inv = pinv(@player);
	}
	foreach(@slot: @data in @inv) {
		if(is_null(@slot)) {
			continue();
		}
		if(_attributes_item_has_attribute(@attribute, @data)) {
			return(true);
		}
	}
	return(false);
}

proc _attributes_remove_items_with_attribute(@attribute, @player) {
	@inv = pinv(@player);
	foreach(@slot: @data in @inv) {
		if(is_null(@slot)) {
			continue();
		}
		if(_attributes_item_has_attribute(@attribute, @data)) {
			@inv[@slot] = null;
		}
	}
	set_pinv(@player, @inv);
	return(true);
}
