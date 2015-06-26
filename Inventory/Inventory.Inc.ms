proc _inventory_lore_exists(@item) {
	return(
		is_array(@item)
		&& array_index_exists(@item, "meta")
		&& is_array(@item["meta"])
		&& array_index_exists(@item["meta"], "lore")
		&& is_array(@item["meta"]["lore"]);
	);
};
