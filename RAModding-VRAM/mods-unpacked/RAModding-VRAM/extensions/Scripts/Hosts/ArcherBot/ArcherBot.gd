extends "res://Scripts/Hosts/ArcherBot/ArcherBot.gd"

func handle_skin():
	enemy_fx.get_node("CASHParticles").emitting = false
	if not override_skin.is_empty():
		sprite.texture = Util.get_cached_texture(override_skin)
		#bow_sprite.texture = Util.get_cached_texture(bow_textures[override_skin])
		return
	if is_player:
		set_skin_from_skin_manager(Engine.get_singleton("VRAM_SkinsManager").get_player_skin_id(Enemy.EnemyType.ARCHER))
		enemy_fx.get_node("CASHParticles").emitting = Engine.get_singleton("VRAM_SkinsManager").get_player_skin(Enemy.EnemyType.ARCHER)["name"] == "CASH"
		return
	set_skin_from_skin_manager("0")

func set_skin_from_skin_manager(skin_id):
	var skin = Engine.get_singleton("VRAM_SkinsManager").get_skin_or_default(Enemy.EnemyType.ARCHER, skin_id)
	sprite.texture = Util.get_cached_texture(skin["sprite_sheet_path"])
	bow_sprite.texture = Util.get_cached_texture(skin["secondary_sprite_sheet_path"])
