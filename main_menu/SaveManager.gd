extends Node

const CONFIG_PATH := "user://config.ini"

func firstpostion():
	var config := ConfigFile.new()
	config.set_value("player", "respawn_x", -800)
	config.set_value("player", "respawn_y",-188)
	config.save(CONFIG_PATH)
	
