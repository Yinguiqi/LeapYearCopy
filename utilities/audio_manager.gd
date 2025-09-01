extends Node

enum Bus { MASTER, SFX, BGM }

@onready var bgm_player: AudioStreamPlayer = $BGMPlayer
@onready var sfx: Node = $SFX


func play_bgm(stream: AudioStream) -> void:
	if bgm_player == stream and bgm_player.playing:
		return
	bgm_player.stream = stream
	bgm_player.play()


func get_volume(bus_index: int) -> float:
	var db := AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(db)

func set_volume(bus_index: int, v: float) -> void:
	var  db := linear_to_db(v)
	AudioServer.set_bus_volume_db(bus_index, db)
	
func play_sfx(name: String) -> void:
	var player := sfx.get_node(name) as AudioStreamPlayer
	if not player:
		return
	player.play()
