extends Control

@onready var main_scene_bgm: AudioStream = preload("res://assets/audio/mus_cave.mp3")

func _on_play_pressed() -> void:
	 # 首先切换音乐
	AudioManager.change_bgm(main_scene_bgm)
	# 然后切换场景
	get_tree().change_scene_to_file("res://main_menu/main.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/options_meun.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
