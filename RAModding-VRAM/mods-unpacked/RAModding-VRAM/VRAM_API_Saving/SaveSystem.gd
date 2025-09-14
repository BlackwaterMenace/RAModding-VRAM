extends Node

const SAVES_DIR_PATH = "user://mod_saves"

#region Backend (Collapse this)

var mods_data = {}
var serializers = {}
var deserializers = {}

func serialize() -> Dictionary:
	return mods_data

func deserialize(save_data: Dictionary):
	mods_data = save_data

func load_saves():
	ModLoaderLog.info("Reading saves...", "RAModding-VRAM")
	for curr_mod_id in deserializers:
		load_save(curr_mod_id)
	ModLoaderLog.info("Finished reading saves.", "RAModding-VRAM")

func load_save(mod_id):
	ModLoaderLog.debug("Reading save for %s" % mod_id, "RAModding-VRAM")
	var save_file = FileAccess.open(SAVES_DIR_PATH.path_join("%s.json" % mod_id), FileAccess.READ)
	var parsed_save_data = {}
	if save_file:
		parsed_save_data = parse(save_file)
	else:
		ModLoaderLog.info("Could not find any existing save for %s." % [mod_id, FileAccess.get_open_error()], "RAModding-VRAM")
	deserializers[mod_id].call(parsed_save_data)

func parse(save_file: FileAccess) -> Dictionary:
	var json = JSON.new()
	var parse_success
	if is_instance_valid(save_file):
		parse_success = json.parse(save_file.get_as_text())
	else:
		parse_success = ERR_PARSE_ERROR
	if parse_success != OK:
		ModLoaderLog.error("VRAM: Could not parse save file at %s" % save_file.get_path_absolute(), "RAModding-VRAM")
	return json.get_data()

func write_saves():
	ModLoaderLog.info("Writing saves...", "RAModding-VRAM")
	var dir_access = DirAccess.open(SAVES_DIR_PATH)
	if !dir_access:
		DirAccess.make_dir_absolute(SAVES_DIR_PATH)
	
	for curr_mod_id in serializers:
		var mod_data = serializers[curr_mod_id].call()
		write_save(curr_mod_id, mod_data)
	ModLoaderLog.info("Finished writing saves.", "RAModding-VRAM")

func write_save(mod_id: String, mod_data: Dictionary):
	ModLoaderLog.debug("Writing save for %s" % mod_id, "RAModding-VRAM")
	var save_file = FileAccess.open(SAVES_DIR_PATH.path_join("%s.json" % mod_id), FileAccess.WRITE)
	save_file.store_string(JSON.stringify(mod_data, '\t'))
	save_file.close()

#endregion

### Provides a framework for mods to save and load data.
### Recommended for medium-to-large-scale mods that require persistent data more niche or extensive than the other VRAM APIs provide by default.
### Saving/loading occurs at the same times that the base game saves or loads.
### 
### Persistence between play sessions using saving/loading requires mods to use "register_mod" in their mod_main.gd file.
### 
### For those unfamiliar with de/serialization:
### Serialization is the act of recording the runtime state of an object or system in a program to reproduce it in a separate runtime instance.
### Deserialization is the act of setting the runtime state, such as save flags and progress, from a file.
### Your serializer should be a func that puts all save flags or other important data that should be persisted between play sessions into a Dictionary.
### This Dict will then be written to a file, where it will later be retrieved and the program state restored.
### Your deserializer should then be able to take the same Dictionary and write the same values to every flag based on that Dict's contents.
### If no save file is found for your mod (e.g. the first time the user uses the mod), the deserializer will receive a blank dict ({}).
### You may need 
### 
### VRAM's save system automatically performs serialization and deserialization, writing to your mod's save file whenever the game writes to its own save file.
### All you have to do is provide the ser/deser methods.
### 
### This framework allows you to easily add, change, and access save flags using "set_or_add_data" and "get_data_or_default" methods.
### Mods may still use their own data structures to store save flags (e.g. extending a vanilla class like Progression.gd to store progression data), but this is not recommended due to potential for mod conflicts.

## Registers the specified mod with the specified serializer and derserializer.
## 
## Assigns the specified de/serializer to the specified mod.
## These de/serializers are used when saving or loading.
## This method should be called at once in mod_main.gd, or not at all.
##
## The serializer should take no parameters and return a Dictionary.
## The deserializer should take only a Dictionary as a parameter and return nothing.
## 
## Note: mods that use the "set_or_add_data(mod_id, key, value)" and "get_data_or_default(mod_id, key, default)" methods should also use them when serializing or deserializing.
func register_mod(mod_id: String, serializer: Callable, deserializer: Callable):
	ModLoaderLog.info("Registering %s..." % mod_id, "RAModding-VRAM")
	serializers[mod_id] = serializer
	deserializers[mod_id] = deserializer
	ModLoaderLog.info("Finished registering %s" % mod_id, "RAModding-VRAM")

## Sets or adds a save flag with the specified value for the specified mod.
##
## Registers a save flag for the specified mod with the specified access key and value, or sets the flag if it is already registered.
## Unless you are editing a flag from a dependency, mod_id should always be the same across all invocations in your specific mod.
func set_or_add_data(mod_id: String, key: String, value: Variant):
	if mods_data[mod_id] == null:
		mods_data[mod_id] = {}
	mods_data[mod_id][key] = value

## Gets the specified save flag for the specified mod, or a default value.
## 
## Gets the save flag registered with the specified key and mod_id, or the specified default if no such flag was registered.
## Unless you are retrieving a flag from a dependency, mod_id should always be the same across all invocations in your specific mod.
func get_data_or_default(mod_id: String, key: String, default: Variant):
	if mods_data[mod_id] == null:
		return default
	return mods_data[mod_id].get(key, default)
