extends Node2D

@onready var camera2d : Camera2D = $Camera2D
@onready var player := $Player
@export var bgm: AudioStream
const CONFIG_PATH := "user://config.ini"
var has_moved := false

func _ready() -> void:
	var config := ConfigFile.new()
	config.load(CONFIG_PATH)
	player.load_player_config(config)
	if bgm:
		AudioManager.play_bgm(bgm)

func _process(delta: float) -> void:
	if not has_moved and player.global_position.x > 960:
		has_moved = true
		var tween := create_tween()
		tween.tween_property(camera2d, "global_position:x", 1920, 0.5)
		
	if  has_moved and player.global_position.x < 960:
		has_moved = false
		var tween := create_tween()
		tween.tween_property(camera2d, "global_position:x", 0, 0.5)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		# 切换到主菜单场景
		get_tree().change_scene_to_file("res://main_menu/menu.tscn")


	
	
