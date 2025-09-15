extends "res://Scripts/Hosts/WheelBot/WheelBot.gd"

func handle_skin():
	enemy_fx.get_node("CASHParticles").emitting = false
	if not upgrades.is_empty(): # Handle Elites
		for curr_upgrade in upgrades:
			var skin_id = Engine.get_singleton("VRAM_SkinsManager").upgrade_skins[Enemy.EnemyType.WHEEL].get(curr_upgrade)
			if skin_id != null:
				set_skin_from_skin_manager(skin_id)
				return
	elif is_player:
		set_skin_from_skin_manager(Engine.get_singleton("VRAM_SkinsManager").get_player_skin_id(Enemy.EnemyType.WHEEL))
		enemy_fx.get_node("CASHParticles").emitting = Engine.get_singleton("VRAM_SkinsManager").get_player_skin_id(Enemy.EnemyType.WHEEL).contains("CASH")
		return
	set_skin_from_skin_manager("0") # Handle normal enemies

func set_skin_from_skin_manager(skin_id):
	var skin = Engine.get_singleton("VRAM_SkinsManager").get_skin_or_default(Enemy.EnemyType.WHEEL, skin_id)
	sprite.texture = Util.get_cached_texture(skin["sprite_sheet_path"])
# TODO: Add a way for skins to change normal and Shaped Charges arms
