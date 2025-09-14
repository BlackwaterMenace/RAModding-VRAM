extends "res://Scripts/UI/ItemPopup.gd"

func setup_upgrade_panel():
	super()
	var bot_id: Enemy.EnemyType = Upgrades.upgrades[upgrade]['type']
	
	var VRAM_SM = Engine.get_singleton("VRAM_SkinsManager")
	
	var skin_id = VRAM_SM.player_skins[bot_id]
	var icon = VRAM_SM.get_skin_or_default(bot_id, skin_id)["path"]
	
	character.texture = Util.get_cached_texture(icon)
