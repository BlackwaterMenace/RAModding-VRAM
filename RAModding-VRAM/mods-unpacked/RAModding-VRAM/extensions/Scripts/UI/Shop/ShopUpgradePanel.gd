extends "res://Scripts/UI/Shop/ShopUpgradePanel.gd"

func set_upgrade(upgrade_name_, price_mod = 1.0):
	super(upgrade_name_, price_mod)
	var upgrade = Upgrades.get_upgrade(upgrade_name_)
	if not upgrade: return
	
	var bot_id: Enemy.EnemyType = upgrade['type']
	var skin_id = VRAM_SkinsManager.player_skins[bot_id]
	var icon = VRAM_SkinsManager.get_skin_or_default(bot_id, skin_id)["path"]
	
	type_icon.texture = Util.get_cached_texture(icon)
