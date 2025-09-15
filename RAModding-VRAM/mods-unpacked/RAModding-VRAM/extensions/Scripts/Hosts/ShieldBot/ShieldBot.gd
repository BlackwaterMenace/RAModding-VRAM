extends "res://Scripts/Hosts/ShieldBot/ShieldBot.gd"

func handle_skin():
	enemy_fx.get_node("CASHParticles").emitting = false
	if is_player:
		if GameManager.player_collider_skin_path != "":
			set_skin_from_skin_manager(Engine.get_singleton("VRAM_SkinsManager").get_player_skin_id(Enemy.EnemyType.SHIELD))
			enemy_fx.get_node("CASHParticles").emitting = Engine.get_singleton("VRAM_SkinsManager").get_player_skin_id(Enemy.EnemyType.SHIELD).contains("CASH")
			return
	set_skin_from_skin_manager("0")

func set_skin_from_skin_manager(skin_id):
	var skin = Engine.get_singleton("VRAM_SkinsManager").get_skin_or_default(Enemy.EnemyType.SHIELD, skin_id)
	sprite.texture = Util.get_cached_texture(skin["sprite_sheet_path"])
