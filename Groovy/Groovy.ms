@temperature = groovy('
	import org.bukkit.Bukkit;

	temperature = Bukkit.getServer().getWorld(world).getTemperature((int) x, (int) z);
', associative_array(
 		world: 'world',
		x: 1000,
		z: 1000,
	),
	array('temperature')
)['temperature'];

console(@temperature);

if(function_exists('groovy')) {
	proc _minecraft_version(@player) {
		if(!ponline(@player)) {
			return();
		}
		@version = groovy('
			import org.bukkit.Bukkit;
			import org.bukkit.entity.Player;
			import com.comphenix.protocol.ProtocolLibrary;

			Player p = Bukkit.getServer().getPlayer(player);
			version = ProtocolLibrary.getProtocolManager().getProtocolVersion(p);
		',	associative_array(player: @player),
			array('version')
		)['version'];
		if(@version == 47) {
			@game = '1.8';
		} else {
			@game = '1.7';
		}
		return(@game);
	}
}
