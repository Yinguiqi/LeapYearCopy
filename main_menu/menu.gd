extends Control

@onready var main_scene_bgm: AudioStream = preload("res://assets/audio/mus_cave.mp3")

@export var bgm: AudioStream

func _ready() -> void:
	if bgm:
		AudioManager.play_bgm(bgm)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/main.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/options_meun.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
