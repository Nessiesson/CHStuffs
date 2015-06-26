if(function_exists('groovy')) {
	proc _temperature(@location) {
		if(!array_index_exists(@location, 'world')) {
			// Assuming that there is always at least one world loaded.
			@location['world'] = get_worlds()[0];
		}
		@temperature = groovy('
			import org.bukkit.Bukkit;

			temperature = Bukkit.getServer().getWorld(world).getTemperature((int) x, (int) z);
		',	associative_array(
				world: @location['world'],
				x: @location['x'];
				z: @location['z'];
			),
			array('temperature')
		)['version'];
		return(@temperature);
	}
}
