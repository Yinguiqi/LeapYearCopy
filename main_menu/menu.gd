extends Control

@export var bgm: AudioStream

const CONFIG_PATH := "user://config.ini"

func _ready() -> void:
	load_config()
	if bgm and not bgm.resource_path.get_file().get_basename().contains("mus_temple"):
		AudioManager.play_bgm(bgm)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/main.tscn")

func _on_continue_pressed() -> void:
	pass # Replace with function body.

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/options_meun.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()





func save_config() -> void:
	var config := ConfigFile.new()
	config.load(CONFIG_PATH)
	config.set_value("audio","master",AudioManager.get_volume(AudioManager.Bus.MASTER))
	config.set_value("audio","sfx",AudioManager.get_volume(AudioManager.Bus.SFX))
	config.set_value("audio","bgm",AudioManager.get_volume(AudioManager.Bus.BGM))
	
	config.save(CONFIG_PATH)
	
func load_config() -> void:
	var config := ConfigFile.new()
	config.load(CONFIG_PATH)
	
	AudioManager.set_volume(
		AudioManager.Bus.MASTER,
		config.get_value("audio","master",0.5)
	)
	AudioManager.set_volume(
		AudioManager.Bus.SFX,
		config.get_value("audio","sfx",1.0)
	)
	AudioManager.set_volume(
		AudioManager.Bus.BGM,
		config.get_value("audio","bgm",1.0)
	)
	
