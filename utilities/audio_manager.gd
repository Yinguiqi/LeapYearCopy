extends Node


func change_bgm(new_music_stream: AudioStream, from_position: float = 0.0) -> void:
	# 获取你的 AudioStreamPlayer 节点，假设你命名为 BGMPlayer
	var bgm_player = $BGMPlayer # 或者你使用的节点名称

	# 如果提供了新的音频流，则设置并播放
	if new_music_stream:
		bgm_player.stream = new_music_stream
		# 如果你希望新音乐循环播放
		bgm_player.stream.loop = true
		bgm_player.play(from_position)
