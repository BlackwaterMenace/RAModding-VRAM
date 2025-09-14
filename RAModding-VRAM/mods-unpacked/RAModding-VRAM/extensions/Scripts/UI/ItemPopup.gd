extends "res://Scripts/UI/ItemPopup.gd"

func setup_upgrade_panel():
	super()
	var bot_id: Enemy.EnemyType = Upgrades.upgrades[upgrade]['type']
	var skin_id = VRAM_SkinsManager.player_skins[bot_id]
	var icon = VRAM_SkinsManager.get_skin_or_default(bot_id, skin_id)["path"]
	
	character.texture = Util.get_cached_texture(icon)
