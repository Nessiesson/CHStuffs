if(function_exists('groovy')) {		
	proc _action_bar(@player, @message) {		
		if(!ponline(@player)) {		
			return();		
		}		
		// Originally written by ConnorLinfoot. Their code can be seen at: https://github.com/ConnorLinfoot/ActionBarAPI		
		groovy('		
			import net.minecraft.server.v1_8_R1.ChatSerializer;		
			import net.minecraft.server.v1_8_R1.IChatBaseComponent;		
			import net.minecraft.server.v1_8_R1.PacketPlayOutChat;		
			import org.bukkit.Bukkit;		
			import org.bukkit.craftbukkit.v1_8_R1.entity.CraftPlayer;		
			import org.bukkit.entity.Player;		
					
			CraftPlayer p = Bukkit.getServer().getPlayer(player);		
					
			IChatBaseComponent cbc = ChatSerializer.a("{text: \\"" + message + "\\"}");		
			PacketPlayOutChat ppoc = new PacketPlayOutChat(cbc, (byte) 2);		
			p.getHandle().playerConnection.sendPacket(ppoc);		
		', associative_array(		
			player: @player,		
			message: colorize(@message),		
		));		
	}		
}
