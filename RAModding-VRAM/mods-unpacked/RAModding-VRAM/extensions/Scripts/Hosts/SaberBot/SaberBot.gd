extends "res://Scripts/Hosts/SaberBot/SaberBot.gd"

func handle_skin():
	if not override_skin.is_empty():
		set_skin_from_skin_manager("%s" % (Progression.tachi_skins.size() - 1))
		return
	if not upgrades.is_empty():
		for curr_upgrade in upgrades:
			var skin_id = VRAM_SkinsManager.upgrade_skins[Enemy.EnemyType.SABER].get(curr_upgrade)
			if skin_id != null:
				set_skin_from_skin_manager(skin_id)
				return
	elif is_player:
		if GameManager.player_tachi_skin_path != "":
			set_skin_from_skin_manager(VRAM_SkinsManager.get_player_skin_id(Enemy.EnemyType.SABER))
			return
	set_skin_from_skin_manager("0")

func set_skin_from_skin_manager(skin_id):
	var skin = VRAM_SkinsManager.get_skin_or_default(Enemy.EnemyType.SABER, skin_id)
	sprite.texture = Util.get_cached_texture(skin["sprite_sheet_path"])
