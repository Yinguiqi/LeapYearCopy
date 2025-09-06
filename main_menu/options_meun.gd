extends Control

@export var bus: StringName = "Master"

@onready var bus_index := AudioServer.get_bus_index(bus)

@onready var volume_slider: HSlider = $MarginContainer/VBoxContainer/HBoxContainer/VolumeSlider


func _ready() -> void:
	volume_slider.value = AudioManager.get_volume(bus_index)
	
	volume_slider.value_changed.connect(func (v: float):
		AudioManager.set_volume(bus_index,v)
		Menu.save_config()
	)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/menu.tscn")


func _on_settings_pressed() -> void:
	pass # Replace with function body.
