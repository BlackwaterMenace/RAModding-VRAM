extends "res://Scripts/Menus/PaintShopMenu.gd"


func _ready():
	super()
	
	var VRAM_SM = Engine.get_singleton("VRAM_SkinsManager")
	
	var steeltoe_icon	= VRAM_SM.get_skin_or_default(Enemy.EnemyType.SHOTGUN, VRAM_SM.player_skins[Enemy.EnemyType.SHOTGUN])["path"]
	var router_icon		= VRAM_SM.get_skin_or_default(Enemy.EnemyType.WHEEL, VRAM_SM.player_skins[Enemy.EnemyType.WHEEL])["path"]
	var aphid_icon		= VRAM_SM.get_skin_or_default(Enemy.EnemyType.FLAME, VRAM_SM.player_skins[Enemy.EnemyType.FLAME])["path"]
	var deadlift_icon	= VRAM_SM.get_skin_or_default(Enemy.EnemyType.CHAIN, VRAM_SM.player_skins[Enemy.EnemyType.CHAIN])["path"]
	var collider_icon	= VRAM_SM.get_skin_or_default(Enemy.EnemyType.SHIELD, VRAM_SM.player_skins[Enemy.EnemyType.SHIELD])["path"]
	var tachi_icon		= VRAM_SM.get_skin_or_default(Enemy.EnemyType.SABER, VRAM_SM.player_skins[Enemy.EnemyType.SABER])["path"]
	var thistle_icon	= VRAM_SM.get_skin_or_default(Enemy.EnemyType.ARCHER, VRAM_SM.player_skins[Enemy.EnemyType.ARCHER])["path"]
	var epitaph_icon	= VRAM_SM.get_skin_or_default(Enemy.EnemyType.BAT, VRAM_SM.player_skins[Enemy.EnemyType.BAT])["path"]
	
	steeltoe_button.icon	= Util.get_cached_texture(steeltoe_icon)
	router_button.icon		= Util.get_cached_texture(router_icon)
	aphid_button.icon		= Util.get_cached_texture(aphid_icon)
	deadlift_button.icon	= Util.get_cached_texture(deadlift_icon)
	collider_button.icon	= Util.get_cached_texture(collider_icon)
	tachi_button.icon		= Util.get_cached_texture(tachi_icon)
	thistle_button.icon		= Util.get_cached_texture(thistle_icon)
	epitaph_button.icon		= Util.get_cached_texture(epitaph_icon)

func update_displayed_skin(skin_index):
	current_index = skin_index
	
	var skin_set = Engine.get_singleton("VRAM_SkinsManager").get_skins_list(currently_displayed_type)
	
	var skin = skin_set[skin_index]
	skin_icon.texture = Util.get_cached_texture(skin['path'])
	skin_name.text = skin['name']
	skin_desc.text = skin['flavour_text']
	current_unlocked = skin_unlocked(skin)
	unlock_reqs.text = tr("ToUnlockSkin") + tr(skin['unlock_requirements'])
	equip_button.disabled = not current_unlocked
	done.visible = current_unlocked
	not_done.visible = not current_unlocked

func skin_unlocked(skin):
	if not 'unlock_flag' in skin: return true
	var unlock_flag = skin['unlock_flag']
	return Engine.get_singleton("VRAM_SkinsManager").is_skin_unlocked(unlock_flag)

#region on_bot_pressed()
func _on_shotgunner_pressed():
	clear_grid()
	currently_displayed_type = Enemy.EnemyType.SHOTGUN
	current_skin_selection = Engine.get_singleton("VRAM_SkinsManager").get_skins_list(currently_displayed_type)
	update_grid()

func _on_wheel_pressed():
	clear_grid()
	currently_displayed_type = Enemy.EnemyType.WHEEL
	current_skin_selection = Engine.get_singleton("VRAM_SkinsManager").get_skins_list(currently_displayed_type)
	update_grid()

func _on_flame_pressed():
	clear_grid()
	currently_displayed_type = Enemy.EnemyType.FLAME
	current_skin_selection = Engine.get_singleton("VRAM_SkinsManager").get_skins_list(currently_displayed_type)
	update_grid()

func _on_chain_pressed():
	clear_grid()
	currently_displayed_type = Enemy.EnemyType.CHAIN
	current_skin_selection = Engine.get_singleton("VRAM_SkinsManager").get_skins_list(currently_displayed_type)
	update_grid()

func _on_collider_pressed():
	clear_grid()
	currently_displayed_type = Enemy.EnemyType.SHIELD
	current_skin_selection = Engine.get_singleton("VRAM_SkinsManager").get_skins_list(currently_displayed_type)
	update_grid()

func _on_tachi_pressed():
	clear_grid()
	currently_displayed_type = Enemy.EnemyType.SABER
	current_skin_selection = Engine.get_singleton("VRAM_SkinsManager").get_skins_list(currently_displayed_type)
	update_grid()

func _on_thistle_pressed():
	clear_grid()
	currently_displayed_type = Enemy.EnemyType.ARCHER
	current_skin_selection = Engine.get_singleton("VRAM_SkinsManager").get_skins_list(currently_displayed_type)
	update_grid()

func _on_epitaph_pressed():
	clear_grid()
	currently_displayed_type = Enemy.EnemyType.BAT
	current_skin_selection = Engine.get_singleton("VRAM_SkinsManager").get_skins_list(currently_displayed_type)
	update_grid()

#endregion

func _on_equip_pressed():
	if not current_unlocked: return
	
	var VRAM_SM = Engine.get_singleton("VRAM_SkinsManager")
	
	var skins_keys = VRAM_SM.get_skins_ids(currently_displayed_type)
	var skin = VRAM_SM.get_skin_or_default(currently_displayed_type, skins_keys[current_index])
	VRAM_SM.set_player_skin(currently_displayed_type, skins_keys[current_index])
	
	
	Util.update_cached_texture(skin['path'])
	var icon_btn
	match currently_displayed_type:
		Enemy.EnemyType.SHOTGUN:
			icon_btn = steeltoe_button
		Enemy.EnemyType.WHEEL:
			icon_btn = router_button
		Enemy.EnemyType.FLAME:
			icon_btn = aphid_button
		Enemy.EnemyType.CHAIN:
			icon_btn = deadlift_button
		Enemy.EnemyType.SHIELD:
			icon_btn = collider_button
		Enemy.EnemyType.SABER:
			icon_btn = tachi_button
		Enemy.EnemyType.ARCHER:
			icon_btn = thistle_button
		Enemy.EnemyType.BAT:
			icon_btn = epitaph_button
	
	icon_btn.icon = Util.get_cached_texture(skin['path'])
	skin_select_audio.play()
	GameManager.player.true_host.handle_skin()
