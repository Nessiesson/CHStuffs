@player = 'CommandHelper';

/*
@loc = ploc(@player);
@loc['y'] += 0.00001;
set_ploc(@player, @loc);
*/
/*
set_timeout(1000, closure() {
set_pvelocity(@player, 0, 0.01, 0)
groovy('
	import org.bukkit.Bukkit;
	import org.bukkit.craftbukkit.v1_8_R1.entity.CraftPlayer;
	import org.bukkit.entity.Player;

	p = Bukkit.getServer().getPlayer(player);

	p.setAllowFlight(true);
	p.setFlying(true);
 ', associative_array(
	player: @player,
));
})
*/
/*
groovy('
	import org.bukkit.Bukkit;
	import org.bukkit.craftbukkit.v1_8_R1.entity.CraftPlayer;
	import org.bukkit.entity.Player;

	p = Bukkit.getServer().getPlayer(player);

	p.setSprinting(true);
 ', associative_array(
	player: @player,
));
console(pinfo(@player, 11))
*/
