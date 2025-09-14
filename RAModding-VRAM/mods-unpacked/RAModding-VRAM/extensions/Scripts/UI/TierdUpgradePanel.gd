extends "res://Scripts/UI/TierdUpgradePanel.gd"

# NOTE: The script this inherits from is preloaded by another script, which makes it so that the Modloader cannot extend it. This file is useless until the preload is removed, at which point it should work without issue.

func set_icons():
	var bot_id: Enemy.EnemyType = Upgrades.upgrades[upgrade]['type']
	var skin_id = VRAM_SkinsManager.player_skins[bot_id]
	var icon = VRAM_SkinsManager.get_skin_or_default(bot_id, skin_id)["path"]
	
	character.texture = Util.get_cached_texture(icon)
	icon.texture = Util.get_cached_texture("res://Art/Upgrades/" + str(upgrade) + ".png")
	
	match(Upgrades.upgrades[upgrade]['type']):
		Enemy.EnemyType.SHOTGUN:
			icon_bg.texture = steeltoe_upgrade_bg
		Enemy.EnemyType.CHAIN:
			icon_bg.texture = deadlift_upgrade_bg
		Enemy.EnemyType.WHEEL:
			icon_bg.texture = router_upgrade_bg
		Enemy.EnemyType.FLAME:
			icon_bg.texture = aphid_upgrade_bg
		Enemy.EnemyType.ARCHER:
			icon_bg.texture = thistle_upgrade_bg
		Enemy.EnemyType.SHIELD:
			icon_bg.texture = collider_upgrade_bg
		Enemy.EnemyType.BAT:
			icon_bg.texture = epitaph_upgrade_bg
		Enemy.EnemyType.SABER:
			icon_bg.texture = tachi_upgrade_bg
