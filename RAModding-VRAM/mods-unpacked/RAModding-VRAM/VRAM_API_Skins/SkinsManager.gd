extends Node

#region Backend (Collapse this)

const HAS_INITIALIZED_BEFORE_KEY = "has_initialized_before"
const PLAYER_SKINS_KEY = "player_skins"
const SKINS_UNLOCK_FLAGS_KEY = "skins_unlock_flags"

var bot_skins := {}
var player_skins := {
	Enemy.EnemyType.SHOTGUN	: "0",
	Enemy.EnemyType.CHAIN	: "0",
	Enemy.EnemyType.FLAME	: "0",
	Enemy.EnemyType.WHEEL	: "0",
	Enemy.EnemyType.SHIELD	: "0",
	Enemy.EnemyType.SABER	: "0",
	Enemy.EnemyType.ARCHER	: "0",
	Enemy.EnemyType.BAT		: "0",
}
var skins_unlock_flags = {
	"unlocked_by_default" : true,
} # NOTE: If Router high-vis or medic skins are ever made available, the id for Bulk Delivery will need to be updated
var upgrade_skins := {
	Enemy.EnemyType.SHOTGUN: {
		"soldering_fingers" : "1",
		"induction_barrel" : "2",
		"stacked_shells" : "3",
	},
	Enemy.EnemyType.CHAIN: {
		"yorikiri" : "1",
		"whiplash" : "2",
		"hassotobi" : "3",
	},
	Enemy.EnemyType.FLAME: {
		"self-laminar_outflow" : "1",
		"aerated_fuel_tanks" : "2",
		"distended_spigot" : "3",
	},
	Enemy.EnemyType.WHEEL: {
		"careful_packing" : "2",
		"self-preservation_override" : "3",
		"bulk_delivery" : "5",
	},
	Enemy.EnemyType.SHIELD: {},
	Enemy.EnemyType.SABER: {
		"spinlock_meditation" : "2",
		"cloak_aerodynamics" : "3",
	},
	Enemy.EnemyType.ARCHER: {},
	Enemy.EnemyType.BAT: {},
}


func _ready():
	ModLoaderLog.info("SkinsManager Ready!", "RAModding-VRAM")
	Engine.get_singleton("VRAM_SaveSystem").register_mod("RAModding-VRAM-SkinsManager", self.serialize, self.deserialize)
	port_vanilla_skins()
	ModLoaderLog.info("Finished setting up SkinsManager.", "RAModding-VRAM")

func port_vanilla_skins():
	ModLoaderLog.debug("Porting vanilla skins...", "RAModding-VRAM")
	await Progression.ready
	
	port_vanilla_main_skins()
	port_thistle_bows()
	port_epitaph_bats()
	
	ModLoaderLog.debug("Finished porting vanilla skins.", "RAModding-VRAM")

func port_vanilla_main_skins():
	for curr_bot_type in Enemy.PlayableEnemyType:
		if !bot_skins.has(curr_bot_type):
			bot_skins[curr_bot_type] = {}
	for i in range(Progression.steeltoe_skins.size()):
		bot_skins[Enemy.EnemyType.SHOTGUN]["%s" % i] = Progression.steeltoe_skins[i]
	for i in range(Progression.deadlift_skins.size()):
		bot_skins[Enemy.EnemyType.CHAIN]["%s" % i] = Progression.deadlift_skins[i]
	for i in range(Progression.router_skins.size()):
		bot_skins[Enemy.EnemyType.WHEEL]["%s" % i] = Progression.router_skins[i]
	for i in range(Progression.aphid_skins.size()):
		bot_skins[Enemy.EnemyType.FLAME]["%s" % i] = Progression.aphid_skins[i]
	for i in range(Progression.collider_skins.size()):
		bot_skins[Enemy.EnemyType.SHIELD]["%s" % i] = Progression.collider_skins[i]
	for i in range(Progression.tachi_skins.size()):
		bot_skins[Enemy.EnemyType.SABER]["%s" % i] = Progression.tachi_skins[i]
	for i in range(Progression.thistle_skins.size()):
		bot_skins[Enemy.EnemyType.ARCHER]["%s" % i] = Progression.thistle_skins[i]
	for i in range(Progression.epitaph_skins.size()):
		bot_skins[Enemy.EnemyType.BAT]["%s" % i] = Progression.epitaph_skins[i]

func port_thistle_bows():
	bot_skins[Enemy.EnemyType.ARCHER]["0"]["secondary_sprite_sheet_path"] = "res://Art/Characters/hermitarcherRAM/spritesheet bow.png"
	bot_skins[Enemy.EnemyType.ARCHER]["1"]["secondary_sprite_sheet_path"] = "res://Art/Characters/hermitarcherRAM/bow colour2.png"
	bot_skins[Enemy.EnemyType.ARCHER]["2"]["secondary_sprite_sheet_path"] = "res://Art/Characters/hermitarcherRAM/bow colour3.png"
	bot_skins[Enemy.EnemyType.ARCHER]["3"]["secondary_sprite_sheet_path"] = "res://Art/Characters/hermitarcherRAM/bow colour1.png"
	bot_skins[Enemy.EnemyType.ARCHER]["4"]["secondary_sprite_sheet_path"] = "res://Art/Characters/hermitarcherRAM/bow colour2.png"
	bot_skins[Enemy.EnemyType.ARCHER]["5"]["secondary_sprite_sheet_path"] = "res://Art/Characters/hermitarcherRAM/WhiteandRedBow1.png"
	bot_skins[Enemy.EnemyType.ARCHER]["6"]["secondary_sprite_sheet_path"] = "res://Art/Characters/hermitarcherRAM/bow colour2.png"

func port_epitaph_bats():
	bot_skins[Enemy.EnemyType.BAT]["0"]["secondary_sprite_sheet_path"] = "res://Art/Characters/bot8 RAM/Batter's Bat Static.png"
	bot_skins[Enemy.EnemyType.BAT]["1"]["secondary_sprite_sheet_path"] = "res://Art/Characters/bot8 RAM/dark skin Bat Static.png"
	bot_skins[Enemy.EnemyType.BAT]["2"]["secondary_sprite_sheet_path"] = "res://Art/Characters/bot8 RAM/Batter's Bat Static.png"
	bot_skins[Enemy.EnemyType.BAT]["3"]["secondary_sprite_sheet_path"] = "res://Art/Characters/bot8 RAM/Batter's Bat Static.png"
	bot_skins[Enemy.EnemyType.BAT]["4"]["secondary_sprite_sheet_path"] = "res://Art/Characters/bot8 RAM/purple skin Bat Static.png"
	bot_skins[Enemy.EnemyType.BAT]["5"]["secondary_sprite_sheet_path"] = "res://Art/Characters/bot8 RAM/Batter's Bat Static.png"
	bot_skins[Enemy.EnemyType.BAT]["6"]["secondary_sprite_sheet_path"] = "res://Art/Characters/bot8 RAM/Batter's Bat White.png"

#region DE/SER

func serialize() -> Dictionary:
	ModLoaderLog.debug("SkinsManager Serialize", "RAModding-VRAM")
	return {
		PLAYER_SKINS_KEY : serialize_player_skins(),
		SKINS_UNLOCK_FLAGS_KEY : serialize_skins_unlock_flags(),
	}

func deserialize(save_data: Dictionary):
	ModLoaderLog.debug("SkinsManager Deserialize", "RAModding-VRAM")
	if save_data.has(PLAYER_SKINS_KEY) && save_data.has(SKINS_UNLOCK_FLAGS_KEY):
		deserialize_player_skins(save_data[PLAYER_SKINS_KEY])
		deserialize_skins_unlock_flags(save_data[SKINS_UNLOCK_FLAGS_KEY])
	else:
		initialize_save_data_from_vanilla()

func serialize_player_skins() -> Dictionary:
	var result = {}
	for curr_bot_type in player_skins:
		result[Enemy.ENEMY_NAME[curr_bot_type]] = player_skins[curr_bot_type]
	return result

func serialize_skins_unlock_flags() -> Dictionary:
	var result = {}
	for curr_skin_unlock_flag in skins_unlock_flags:
		result[curr_skin_unlock_flag] = skins_unlock_flags[curr_skin_unlock_flag]
	return result

func deserialize_player_skins(save_data: Dictionary):
	# Swap keys and values of Enemy.ENEMY_NAME to get the Enemy.EnemyType from the string in save_data
	var enemy_name_to_enemy_type_converter = {}
	for curr_bot in Enemy.PlayableEnemyType:
		enemy_name_to_enemy_type_converter[Enemy.ENEMY_NAME[curr_bot]] = curr_bot
	
	# Set player_skins as one would expect
	for curr_enemy_title in save_data:
		player_skins[enemy_name_to_enemy_type_converter[curr_enemy_title]] = "%s" % save_data[curr_enemy_title]

func deserialize_skins_unlock_flags(save_data: Dictionary):
	for curr_skin_unlock_flag in save_data:
		skins_unlock_flags[curr_skin_unlock_flag] = save_data[curr_skin_unlock_flag]

#endregion

func initialize_save_data_from_vanilla():
	port_vanilla_skin_unlock_flags()
	port_player_skins()

func port_vanilla_skin_unlock_flags():
	await Progression.ready
	for curr_skin in Progression.all_skins:
		var curr_skin_unlock_flag = curr_skin.get("unlock_flag")
		if curr_skin_unlock_flag != null:
			# Case 1: skins_unlock_flags shows skin as being unlocked. Skin remains unlocked.
			# Case 2: skins_unlock_flag is missing (did not have VRAM installed on previous save) or false. Uses vanilla flag value.
			var is_skin_unlocked = skins_unlock_flags.get(curr_skin_unlock_flag, false) || SaveManager.global_progression.progression_flags[curr_skin_unlock_flag]
			skins_unlock_flags[curr_skin_unlock_flag] = is_skin_unlocked
			if is_skin_unlocked:
				ModLoaderLog.success("%s: UNLOCKED!" % curr_skin_unlock_flag, "RAModding-VRAM")

func port_player_skins():
	player_skins[Enemy.EnemyType.ARCHER]	= "%s" % SaveManager.settings.thistle_skin
	player_skins[Enemy.EnemyType.BAT]		= "%s" % SaveManager.settings.epitaph_skin
	player_skins[Enemy.EnemyType.CHAIN]		= "%s" % SaveManager.settings.deadlift_skin
	player_skins[Enemy.EnemyType.FLAME]		= "%s" % SaveManager.settings.aphid_skin
	player_skins[Enemy.EnemyType.SABER]		= "%s" % SaveManager.settings.tachi_skin
	player_skins[Enemy.EnemyType.SHIELD]	= "%s" % SaveManager.settings.collider_skin
	player_skins[Enemy.EnemyType.SHOTGUN]	= "%s" % SaveManager.settings.steeltoe_skin
	player_skins[Enemy.EnemyType.WHEEL]		= "%s" % SaveManager.settings.router_skin

func get_skins_ids(bot_id: Enemy.EnemyType) -> Array:
	var skins_keys: Array = bot_skins[bot_id].keys()
	skins_keys.sort_custom(Engine.get_singleton("VRAM_SkinsManager").sort_skins_keys)
	return skins_keys

func get_skins_list(bot_id: Enemy.EnemyType) -> Array:
	var result = []
	for curr_skin_key in get_skins_ids(bot_id):
		result.append(bot_skins[bot_id][curr_skin_key])
	return result

func sort_skins_keys(a, b):
	var type_a = typeof(a)
	var type_b = typeof(b)
	
	if type_a == TYPE_INT and type_b != TYPE_INT:
		return true
	if type_a != TYPE_INT and type_b == TYPE_INT:
		return false
	if type_a == TYPE_STRING and type_b != TYPE_STRING:
		return true
	if type_a != TYPE_STRING and type_b == TYPE_STRING:
		return false
	
	if type_a == type_b:
		if type_a in [TYPE_INT, TYPE_STRING, TYPE_STRING_NAME]:
			return a < b
		else:
			return false
	return type_a < type_b

func floor_puzzle_completed():
	await Progression.ready
	var skin_key = "%s" % (Progression.router_skins.size() - 1)
	bot_skins[Enemy.EnemyType.WHEEL][skin_key] = Progression.router_skins[Progression.router_skins.size() - 1]

#endregion

## Adds a new skin with the specified information.
## 
## Registers a skin with this SkinsManager using the specified information.
## If a skin with the specified bot_id and skin_id is already registered, replaces it.
## 
## Parameters are as follows:
## * bot_id:						The type of the bot.
## * skin_id:						The identifier that will be used to retrieve the skin. Should be unique per bot across all mods. Suggested format: {namespace}_{mod name}_{skin name}
## * skin_name:					Displayed in the paint shop; name of the skin.
## * flavour_text:					Displayed in the paint shop; flavor text for the skin.
## * unlock_requirements:			Displayed in the paint shop; unlock requirements. Not to be confused with unlock_flag.
## * icon_path:					Displayed in the paint shop; path to the icon sprite.
## * colour:						Displayed in the paint shop; color of the skin as displayed in the paint shop.
## * spritesheet_path:				Path to the main spritesheet.
## * secondary_spritesheet_path:	Path to the secondary spritesheet, if applicable. Used for Deadlift arms, Aphid nozzles, Thistle bows, and Epitaph bats.
## * unlock_flag: 					Name of the flag controlling whether the skin is locked or unlocked. Should be unique to your mod, though not necessarily unique across all skins within a single mod. Suggested format: {namespace}_{mod name}_{fla name}
## * extra_data:					Additional data. Only used for mods.
func register_skin(
	bot_id: Enemy.EnemyType,
	skin_id: String,
	skin_name: String,
	flavour_text: String,
	unlock_requirement: String,
	icon_path: String,
	colour: Color,
	spritesheet_path: String,
	secondary_spritesheet_path: String = "",
	unlock_flag: String = "unlocked_by_default",
	extra_data : Dictionary = {}
):
	if bot_id not in bot_skins: bot_skins[bot_id] = {}
	bot_skins[bot_id][skin_id] = {
		"name"					: skin_name,
		"flavour_text"			: flavour_text,
		"unlock_requirements"	: unlock_requirement,
		"path"					: icon_path,
		"colour"				: colour,
		"sprite_sheet_path"		: spritesheet_path,
		"unlock_flag"			: unlock_flag,
		"extra_data"			: extra_data
	}
	if (bot_id in [Enemy.EnemyType.CHAIN, Enemy.EnemyType.FLAME, Enemy.EnemyType.ARCHER, Enemy.EnemyType.BAT] || !secondary_spritesheet_path.is_empty()):
		bot_skins[bot_id][skin_id]["secondary_sprite_sheet_path"] = secondary_spritesheet_path
	if !skins_unlock_flags.has(unlock_flag):
		skins_unlock_flags[unlock_flag] = false

## Gets the specified skin for the specified bot, or the default skin for the bot if not found.
## 
## Gets a Dictionary containing all data for the specified bot, or the bot with skin_id = "0". Specific fields should be accessed by the dict's keys.
## Assumes that some skin has been registered with skin_id = "0". This is the case for all vanilla bots. Bots added with mods should also do this.
## Further assumes that bot_id represents a bot that has had at least one skin registered, including all vanilla bots.
func get_skin_or_default(bot_id: Enemy.EnemyType, skin_id: String) -> Dictionary:
	return bot_skins[bot_id].get(skin_id, bot_skins[bot_id]["0"])

## Sets the player's skin to skin_id for the specified bot.
## 
## Sets the specified bot's skin to the skin with the specified skin_id for the player.
## If no skin with the specified skin_id was found for that bot, does nothing.
## Does not actually change the player's skin in-game until handle_skin() is called on the player bot.
func set_player_skin(bot_id: Enemy.EnemyType, skin_id: String):
	if skin_id in bot_skins[bot_id]:
		player_skins[bot_id] = skin_id
		var skin_id_as_int = int(skin_id)
		match bot_id:
			Enemy.EnemyType.ARCHER:
				SaveManager.settings.thistle_skin = int(skin_id) if skin_id_as_int < Progression.steeltoe_skins.size() else 0
			Enemy.EnemyType.BAT:
				SaveManager.settings.epitaph_skin = int(skin_id) if skin_id_as_int < Progression.epitaph_skins.size() else 0
			Enemy.EnemyType.CHAIN:
				SaveManager.settings.deadlift_skin = int(skin_id) if skin_id_as_int < Progression.deadlift_skins.size() else 0
			Enemy.EnemyType.FLAME:
				SaveManager.settings.aphid_skin = int(skin_id) if skin_id_as_int < Progression.aphid_skins.size() else 0
			Enemy.EnemyType.SABER:
				SaveManager.settings.tachi_skin = int(skin_id) if skin_id_as_int < Progression.tachi_skins.size() else 0
			Enemy.EnemyType.SHIELD:
				SaveManager.settings.collider_skin = int(skin_id) if skin_id_as_int < Progression.collider_skins.size() else 0
			Enemy.EnemyType.SHOTGUN:
				SaveManager.settings.steeltoe_skin = int(skin_id) if skin_id_as_int < Progression.steeltoe_skins.size() else 0
			Enemy.EnemyType.WHEEL:
				SaveManager.settings.router_skin = int(skin_id) if skin_id_as_int < Progression.router_skins.size() else 0
	else:
		ModLoaderLog.debug("Tried to set bot \"%s\" player skin to inexistent skin %s" % [Enemy.ENEMY_NAME[bot_id], skin_id], "RAModding-VRAM")

## Gets the skin_id for the player for the specified bot.
##
## Returns the skin_id for the player for the specified bot type.
## To get the actual player skin, use this as the skin_id for get_skin_or_default.
func get_player_skin_id(bot_id: Enemy.EnemyType) -> String:
	return player_skins[bot_id]

## Makes it so that Elites with the specified upgrade have the specified skin.
## 
## Registers a skin with an upgrade such that Elites with the specified upgrade use the specified skin.
## Supports both vanilla and mod skins and upgrades.
func register_upgrade_skin(bot_id: Enemy.EnemyType, upgrade_id: String, skin_id: String):
	upgrade_skins[bot_id][upgrade_id] = skin_id

## Unlocks skins associated with the specified flag.
## 
## Unlocks all locked skins that use the specified save flag, and shows a popup for the first skin that is unlocked.
## More specifically, sets the specified flag to true and shows the popup.
## Does nothing if the flag is already unlocked.
func unlock_skin(unlock_flag: String):
	if GameManager.game_mode == GameManager.GameMode.TEST: return
	if SaveManager.global_progression.progression_flags.get(unlock_flag, false) || skins_unlock_flags.get(unlock_flag, false): return
	
	for curr_bot_type in bot_skins:
		for curr_skin_key in bot_skins[curr_bot_type]:
			var curr_skin = bot_skins[curr_bot_type][curr_skin_key]
			if curr_skin.get('unlock_flag') == unlock_flag:
				skins_unlock_flags[unlock_flag] = true
				if SaveManager.global_progression.progression_flags.has(unlock_flag):
					SaveManager.global_progression.progression_flags[unlock_flag] = true
				Progression.show_unlock_popup(curr_skin)
				return

## Returns whether or not the current skin is unlocked.
## 
## Returns whether the specified skin unlock flag is raised. All bots that use that flag are unlocked if it returns true
## Checks both the vanilla flags and the SkinsManager unlock system. If it is unlocked in either, returns true.
## Returns false if the flag cannot be found.
func is_skin_unlocked(unlock_flag: String) -> bool:
	return skins_unlock_flags.get(unlock_flag, false) || SaveManager.global_progression.progression_flags.get(unlock_flag, false)
