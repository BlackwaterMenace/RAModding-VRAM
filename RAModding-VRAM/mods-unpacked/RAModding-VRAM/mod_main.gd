extends Node

const MOD_DIR := "RAModding-VRAM"
const LOG_NAME := "RAModding-VRAM:Main"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

func _init() -> void:
	ModLoaderLog.info("Init", LOG_NAME)
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(MOD_DIR)
	
	# Add extensions
	install_script_extensions()
	install_script_hook_files()
	install_singletons()

func install_script_extensions() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")
	
	# Allow saving and loading
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Globals/SaveManager.gd"))
	# Allow unlocking skins
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Globals/Progression.gd"))

	# Show current skin's icon on upgrade panels
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Scripts/UI/Shop/ShopUpgradePanel.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Scripts/UI/ItemPopup.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Scripts/UI/TierdUpgradePanel.gd"))
	
	# Make skin selection use SkinsManager
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Scripts/Menus/PaintShopMenu.gd"))
	
	# Make bots use SkinsManager for skin retrieval, and improve skin equipping
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Scripts/Hosts/FlameBot/FlameBot.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Scripts/Hosts/WheelBot/WheelBot.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Scripts/Hosts/ShieldBot/ShieldBot.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Scripts/Hosts/SaberBot/SaberBot.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Scripts/Hosts/ArcherBot/ArcherBot.gd"))

func install_script_hook_files() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")
	
	# Make bots use SkinsManager for skin retrieval, and improve skin equipping
	ModLoaderMod.install_script_hooks("res://Scripts/Hosts/ChainBot/ChainBot.gd", extensions_dir_path.path_join("Scripts/Hosts/ChainBot/ChainBot.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Hosts/ShotgunBot/ShotgunBot.gd", extensions_dir_path.path_join("Scripts/Hosts/ShotgunBot/ShotgunBot.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://Scripts/Hosts/BatBot/BatBot.gd", extensions_dir_path.path_join("Scripts/Hosts/BatBot/BatBot.hooks.gd"))

func install_singletons():
	var save_system =	load("res://mods-unpacked/RAModding-VRAM/VRAM_API_Saving/SaveSystem.gd").new()
	var skins_manager =	load("res://mods-unpacked/RAModding-VRAM/VRAM_API_Skins/SkinsManager.gd").new()
	Engine.register_singleton("VRAM_SaveSystem", save_system)
	Engine.register_singleton("VRAM_SkinsManager", skins_manager)
	add_child(save_system)
	add_child(skins_manager)

func _ready() -> void:
	ModLoaderLog.info("Ready", LOG_NAME)
