_attributes_register_attribute('Godly');
_attributes_register_attribute('Speed');

bind('entity_damage', array('id': 'attributes_Godly'), array('type': 'PLAYER'), @event) {
	if(_attributes_has_item_with_attribute('Godly', @event['player'])) {
		cancel();
	};
};

set_interval(5000, 0, closure() {
	@players = array();
	foreach(@player in all_players()) {
		@players[@player] = pinv(@player);
	};
	x_new_thread('Speed', closure() {
		foreach(@player: @inventory in @players) {
			if(_attributes_has_item_with_attribute('Speed', @player, @inventory)) {
				x_run_on_main_thread_later(closure() {
					if(ponline(@player)) {
						set_peffect(@player, 1, 0, 9, true);
					};
				});
			};
		};
	});
});
