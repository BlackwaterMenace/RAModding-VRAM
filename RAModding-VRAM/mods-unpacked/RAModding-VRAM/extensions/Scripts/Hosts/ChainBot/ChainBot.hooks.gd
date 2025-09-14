extends Object

func handle_skin(chain: ModLoaderHookChain):
	var base_obj = chain.reference_object as ChainBot
	
	if base_obj.ignore_skin: return
	
	if not base_obj.upgrades.is_empty(): # Handle Elites
		for curr_upgrade in base_obj.upgrades:
			var skin_id = VRAM_SkinsManager.upgrade_skins[Enemy.EnemyType.CHAIN].get(curr_upgrade)
			if skin_id != null:
				set_skin_from_skin_manager(base_obj, skin_id)
				return
	elif base_obj.is_player:
		set_skin_from_skin_manager(base_obj, VRAM_SkinsManager.get_player_skin_id(Enemy.EnemyType.CHAIN))
		return
	set_skin_from_skin_manager(base_obj, "0") # Handle normal enemies

func set_skin_from_skin_manager(base_obj: ChainBot, skin_id):
	var skin = VRAM_SkinsManager.get_skin_or_default(Enemy.EnemyType.CHAIN, skin_id)
	base_obj.sprite.texture = Util.get_cached_texture(skin["sprite_sheet_path"])
	base_obj.arm_sprite.texture = Util.get_cached_texture(skin["secondary_sprite_sheet_path"])
