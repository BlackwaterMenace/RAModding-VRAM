extends "res://Globals/Progression.gd"

func unlock_skin(unlock_flag):
	Engine.get_singleton("VRAM_SkinsManager").unlock_skin(unlock_flag)

func floor_puzzle_completed():
	super()
	Engine.get_singleton("VRAM_SkinsManager").floor_puzzle_completed()
