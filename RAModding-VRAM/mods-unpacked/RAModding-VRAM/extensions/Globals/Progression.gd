extends "res://Globals/Progression.gd"

func unlock_skin(unlock_flag):
	VRAM_SkinsManager.unlock_skin(unlock_flag)

func floor_puzzle_completed():
	super()
	VRAM_SkinsManager.floor_puzzle_completed()
