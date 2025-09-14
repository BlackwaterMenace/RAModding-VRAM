extends "res://Scripts/Hosts/ArcherBot/ArcherBot.gd"

func handle_skin():
	if not override_skin.is_empty():
		sprite.texture = Util.get_cached_texture(override_skin)
		#bow_sprite.texture = Util.get_cached_texture(bow_textures[override_skin])
		return
	if is_player:
		set_skin_from_skin_manager(VRAM_SkinsManager.get_player_skin_id(Enemy.EnemyType.ARCHER))
		return
	set_skin_from_skin_manager("0")

func set_skin_from_skin_manager(skin_id):
	var skin = VRAM_SkinsManager.get_skin_or_default(Enemy.EnemyType.ARCHER, skin_id)
	sprite.texture = Util.get_cached_texture(skin["sprite_sheet_path"])
	bow_sprite.texture = Util.get_cached_texture(skin["secondary_sprite_sheet_path"])
