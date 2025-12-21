extends Object

func handle_skin(chain: ModLoaderHookChain):
	print("HERE")
	var base_obj = chain.reference_object as ChainBot
	
	if base_obj.ignore_skin: return
	base_obj.enemy_fx.get_node("CASHParticles").emitting = false
	if not base_obj.upgrades.is_empty(): # Handle Elites
		for curr_upgrade in base_obj.upgrades:
			var skin_id = Engine.get_singleton("VRAM_SkinsManager").upgrade_skins[Enemy.EnemyType.CHAIN].get(curr_upgrade)
			if skin_id != null:
				set_skin_from_skin_manager(base_obj, skin_id)
				return
	elif base_obj.is_player:
		set_skin_from_skin_manager(base_obj, Engine.get_singleton("VRAM_SkinsManager").get_player_skin_id(Enemy.EnemyType.CHAIN))
		base_obj.enemy_fx.get_node("CASHParticles").emitting = Engine.get_singleton("VRAM_SkinsManager").get_player_skin(Enemy.EnemyType.CHAIN)["name"] == "CASH"
		return
	set_skin_from_skin_manager(base_obj, "0") # Handle normal enemies

func set_skin_from_skin_manager(base_obj: ChainBot, skin_id):
	var skin = Engine.get_singleton("VRAM_SkinsManager").get_skin_or_default(Enemy.EnemyType.CHAIN, skin_id)
	base_obj.sprite.texture = Util.get_cached_texture(skin["sprite_sheet_path"])
	base_obj.arm_sprite.texture = Util.get_cached_texture(skin["secondary_sprite_sheet_path"])
