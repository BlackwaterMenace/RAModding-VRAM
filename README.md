## VRAM (Various RAM APIs for Modding) - RAModding
# Introduction
VRAM is a set of APIs, accessed through custom singleton classes, designed to:
* Standardize RAM mods to have minimal conflicts
* Massively simplify the creation of basic mods
* Offer tools for making larger-scale mods

# Functionality
VRAM currently offers the following functionality:
* Skins mangement
    * Adding skins to all vanilla bots.
    * Unlocking skins*.
    * Exposing modded skins to vanilla features (e.g. unlock popups*, paint shop selection, skin selection persistence via save files, etc.)
* Save file management
    * Adding, getting, and setting custom save flags.
    * Registering mods with our custom save system to keep track of flags on a per-mod basis, rather than risking naming conflicts or other incompatibilities.
    * Making custom save files for each registered mod, preventing save data from being lost if users ever have to disable your mod and return to it later.

\* Individual mods still need to handle checking conditions, as those will vary for each mod.

# Known issues:
* Upgrade selection does not show non-vanilla skins when picking up a ram stick upgrade. This cannot be fixed at this time.

# API documentation:

## VRAMSkinsManager
Allows users to add skins to the game. Currently only known to support vanilla bots, due to lack of bot mods to test with.
Skins can be unlocked by default, or unlocked using this API based on some mod-specific and mod-implemented condition.
Skins are integrated as seamlessly as possible.

### register_skin
Registers a skin using the specified information.
If a skin with the specified bot_id and skin_id is already registered, replaces it.
Parameters are as follows:
* bot_id:						The type of the bot.
* skin_id:						The identifier that will be used to retrieve the skin. Should be unique per bot across all mods. Suggested format: {namespace}_{mod name}_{skin name}
* skin_name:					Displayed in the paint shop; name of the skin.
* flavour_text:					Displayed in the paint shop; flavor text for the skin.
* unlock_requirements:			Displayed in the paint shop; unlock requirements. Not to be confused with unlock_flag.
* icon_path:					Displayed in the paint shop; path to the icon sprite.
* colour:						Displayed in the paint shop; color of the skin as displayed in the paint shop.
* spritesheet_path:				Path to the main spritesheet.
* secondary_spritesheet_path:	Path to the secondary spritesheet, if applicable. Used for Deadlift arms, Aphid nozzles, Thistle bows, and Epitaph bats.
* unlock_flag: 					Name of the flag controlling whether the skin is locked or unlocked. Should be unique to your mod, though not necessarily unique across all skins within a single mod.
    * Suggested format: {namespace}_{mod name}_{fla name}
* extra_data:					Additional data. Only used for mods.

static func register_skin(
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
) -> void

### get_skin_or_default
Gets a Dictionary containing all data for the specified bot, or the bot with skin_id = "0". Specific fields should be accessed by the dict's keys.
Assumes that some skin has been registered with skin_id = "0". This is the case for all vanilla bots. Bots added with mods should also do this.
Further assumes that bot_id represents a bot that has had at least one skin registered, including all vanilla bots.

static func get_skin_or_default(
    bot_id: Enemy.EnemyType,
    skin_id: String
) -> Dictionary

### set_player_skin
Sets the specified bot's skin to the skin with the specified skin_id for the player.
If no skin with the specified skin_id was found for that bot, does nothing.
Does not actually change the player's skin in-game until handle_skin() is called on the player bot.

static func set_player_skin(
    bot_id: Enemy.EnemyType,
    skin_id: String
) -> void

### get_player_skin_id
Returns the skin_id for the player for the specified bot type.
To get the actual player skin, use this as the skin_id for get_skin_or_default.

static func get_player_skin_id(
    bot_id: Enemy.EnemyType
) -> String:

### register_upgrade_skin
Registers a skin with an upgrade such that Elites with the specified upgrade use the specified skin.
Supports both vanilla and mod skins and upgrades.

static func register_upgrade_skin(
    bot_id: Enemy.EnemyType,
    upgrade_id: String,
    skin_id: String
) -> void

### unlock_skin
Unlocks all locked skins that use the specified save flag, and shows a popup for the first skin that is unlocked.
More specifically, sets the specified flag to true and shows the popup.
Does nothing if the flag is already unlocked.
Mods that lock skins behind non-vanilla flags should call this method when the unlock condition is met.

static func unlock_skin(
    unlock_flag: String
) -> void

### is_skin_unlocked
Returns whether the specified skin unlock flag is raised. All bots that use that flag are unlocked if it returns true.
Checks both the vanilla flags and the SkinsManager unlock system. If it is unlocked in either, returns true.
Returns false if the flag cannot be found.

static func is_skin_unlocked(
    unlock_flag: String
) -> bool

## VRAM-SaveSystem

Provides a framework for mods to save and load data.
Recommended for medium-to-large-scale mods that require persistent data more niche or extensive than the other VRAM APIs provide by default.
Saving/loading occurs at the same times that the base game saves or loads.

Persistence between play sessions using saving/loading requires mods to use "register_mod" in their mod_main.gd file.

For those unfamiliar with de/serialization:
Serialization is the act of recording the runtime state of an object or system in a program to reproduce it in a separate runtime instance.
Deserialization is the act of setting the runtime state, such as save flags and progress, from a file.
Your serializer should be a func that puts all save flags or other important data that should be persisted between play sessions into a Dictionary.
This Dict will then be written to a file, where it will later be retrieved and the program state restored.
Your deserializer should then be able to take the same Dictionary and write the same values to every flag based on that Dict's contents.
If no save file is found for your mod (e.g. the first time the user uses the mod), the deserializer will receive a blank dict ({}).
You may need 

VRAM's save system automatically performs serialization and deserialization, writing to your mod's save file whenever the game writes to its own save file.
All you have to do is provide the ser/deser methods.

This framework allows you to easily add, change, and access save flags using "set_or_add_data" and "get_data_or_default" methods.
Mods may still use their own data structures to store save flags (e.g. extending a vanilla class like Progression.gd to store progression data), but this is not recommended due to potential for mod conflicts.

### register_mod
Registers the specified mod with the specified serializer and derserializer.
These de/serializers are used when saving or loading.
This method should be called at once in mod_main.gd, or not at all.
The serializer should take no parameters and return a Dictionary.
The deserializer should take only a Dictionary as a parameter and return nothing.
Note: mods that use the "set_or_add_data(mod_id, key, value)" and "get_data_or_default(mod_id, key, default)" methods should also use them when serializing or deserializing.

static func register_mod(
    mod_id: String,
    serializer: Callable,
    deserializer: Callable
) -> void

### set_or_add_data
Registers a save flag for the specified mod with the specified access key and value, or sets the flag if it is already registered.
Unless you are editing a flag from a dependency, mod_id should always be the same across all invocations in your specific mod.

static func set_or_add_data(
    mod_id: String
    key: String,
    value: Variant
) -> void

### get_data_or_default
Gets the save flag registered with the specified key and mod_id, or the specified default if no such flag was registered.
Unless you are retrieving a flag from a dependency, mod_id should always be the same across all invocations in your specific mod.

static func get_data_or_default(
    mod_id: String,
    key: String,
    default: Variant
) -> Variant