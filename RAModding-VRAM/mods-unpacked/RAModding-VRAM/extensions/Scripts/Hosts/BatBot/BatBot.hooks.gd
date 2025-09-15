extends Object

func handle_skin(chain: ModLoaderHookChain):
	var base_obj = chain.reference_object as BatBot
	
	base_obj.enemy_fx.get_node("CASHParticles").emitting = false
	if not base_obj.override_skin.is_empty():
		base_obj.sprite.texture = Util.get_cached_texture(base_obj.override_skin)
		return
	if base_obj.is_player:
		set_skin_from_skin_manager(base_obj, Engine.get_singleton("VRAM_SkinsManager").get_player_skin_id(Enemy.EnemyType.BAT))
		base_obj.enemy_fx.get_node("CASHParticles").emitting = Engine.get_singleton("VRAM_SkinsManager").get_player_skin_id(Enemy.EnemyType.BAT).contains("CASH")
		return
	set_skin_from_skin_manager(base_obj, "0") # Handle normal enemies

func set_skin_from_skin_manager(base_obj: BatBot, skin_id):
	var skin = Engine.get_singleton("VRAM_SkinsManager").get_skin_or_default(Enemy.EnemyType.BAT, skin_id)
	base_obj.sprite.texture = Util.get_cached_texture(skin["sprite_sheet_path"])
	base_obj.paddle_sprite.texture = Util.get_cached_texture(skin["secondary_sprite_sheet_path"])
