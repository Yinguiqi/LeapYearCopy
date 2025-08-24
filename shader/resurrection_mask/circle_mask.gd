extends Control

@onready var shader_material = $ColorRect.material
@onready var timer: Timer = $"../Timer"
signal animation_finished

# 播放扩大动画
func play_expand_animation(duration: float = 0.5):
	# 创建动画
	var tween = create_tween()
	
	# 从0扩大到1.0（覆盖整个屏幕）
	tween.tween_method(
		_update_shader_radius, 
		2.0,   # 起始值（最小）
		0.0,   # 结束值（最大）
		duration
	)
	
	# 设置缓动函数
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	await get_tree().create_timer(0.5).timeout
	# 动画完成后发出信号
	tween.finished.connect(queue_free)

# 播放缩小动画
func play_shrink_animation(duration: float = 0.5):
	# 创建动画
	var tween = create_tween()
	
	# 从1.0缩小到0
	tween.tween_method(
		_update_shader_radius,
		0.0,   # 起始值（最大）
		2.0,   # 结束值（最小）
		duration
	)
	
	# 设置缓动函数
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	# 动画结束后销毁节点
	tween.finished.connect(queue_free)

# 更新着色器radius参数的回调函数
func _update_shader_radius(value: float):
	shader_material.set_shader_parameter("radius", value)

# 动画完成时的处理
#func _on_animation_finished():
	#emit_signal("animation_finished")
