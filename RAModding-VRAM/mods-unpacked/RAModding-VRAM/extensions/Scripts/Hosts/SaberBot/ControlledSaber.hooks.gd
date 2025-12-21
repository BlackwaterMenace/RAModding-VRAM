extends Object

func set_source(chain: ModLoaderHookChain, source_):
	chain.execute_next([source_])
	if (source_ as Enemy).is_player:
		var saber_color = Engine.get_singleton("VRAM_SkinsManager").get_player_skin(Enemy.EnemyType.SABER)["extra_data"].get("saber_color", Color.WHITE)
		(chain.reference_object as ControlledSaber).get_node("Sprite2D").modulate = saber_color if saber_color is Color else Color.WHITE
		
func get_free_saber(chain: ModLoaderHookChain):
	var free_saber = chain.execute_next()
	free_saber.get_node("Sprite2D").modulate = (chain.reference_object as ControlledSaber).get_node("Sprite2D").modulate
	return free_saber
