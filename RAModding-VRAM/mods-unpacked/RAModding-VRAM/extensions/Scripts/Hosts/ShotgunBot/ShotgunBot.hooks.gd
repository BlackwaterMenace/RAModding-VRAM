extends Object

func handle_skin(chain: ModLoaderHookChain):
	var base_obj = chain.reference_object as ShotgunBot
	
	if not base_obj.upgrades.is_empty(): # Handle Elites
		for curr_upgrade in base_obj.upgrades:
			var skin_id = VRAM_SkinsManager.upgrade_skins[Enemy.EnemyType.SHOTGUN].get(curr_upgrade)
			if skin_id != null:
				set_skin_from_skin_manager(base_obj, skin_id)
				return
	elif base_obj.is_player:
		set_skin_from_skin_manager(base_obj, VRAM_SkinsManager.get_player_skin_id(Enemy.EnemyType.SHOTGUN))
		return
	set_skin_from_skin_manager(base_obj, "0") # Handle normal enemies

func set_skin_from_skin_manager(base_obj: ShotgunBot, skin_id: String):
	var skin = VRAM_SkinsManager.get_skin_or_default(Enemy.EnemyType.SHOTGUN, skin_id)
	base_obj.sprite.texture = Util.get_cached_texture(skin["sprite_sheet_path"])
