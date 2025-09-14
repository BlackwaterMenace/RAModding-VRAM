extends "res://Globals/SaveManager.gd"

### This extension is specifically to insert our own serialization and deserialization.

# Base RAM's load_save() method calls wrie_save at the end, so my options were:
# 1. Call VRAM's load_saves BEFORE super.load_save(), forcing all mods to initialize without access to the vanilla save file on every load.
# 2. Call VRAM's load_saves AFTER super.load_save(), which means doing VRAM.write_saves() before VRAM.load_saves(), probably wiping mod saves on every load and defeating the purpose of the save system in the first place.
# 3. Extend super.serialize() and super.deserializer() instead, forcing me to either discard the feature of mod-specific save files or severely violate the Single Responsibility Principle by having VRAM.serialize() also handle save loading.
# I went with #2. I can fix the problem that this option presents by checking if this is the first time the game is writing to the save in this play session, and Not doing that if so.
var has_loaded_save_data = false

func _ready():
	ModLoaderLog.debug("SaveManager Ready!", "RAModding-VRAM")
	var VRAM_SS = Engine.get_singleton("VRAM_SaveSystem")
	VRAM_SS.register_mod("RAModding-VRAM-SaveSystem", VRAM_SS.serialize, VRAM_SS.deserialize)
	super()


# Options:
# 1. extend ser/deser, lose mod-specific saves
# 2. Do VRAM load_saves before super.load_saves(), lose access to vanilla save file when initializing mods
# 
# 
# 
# 
# 


func load_save():
	super()
	Engine.get_singleton("VRAM_SaveSystem").load_saves()
	has_loaded_save_data = true

func write_save():
	super()
	if has_loaded_save_data:
		Engine.get_singleton("VRAM_SaveSystem").write_saves()
