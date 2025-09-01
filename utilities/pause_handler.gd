extends Node
@onready var camera2d : Camera2D = $"../Camera2D"
@onready var player : CharacterBody2D = $"../Player"
@onready var timer: Timer = $"../Timer"
func _ready():
	# 确保节点在暂停时仍能处理输入
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
	# 当游戏暂停且按下空格键时
	if get_tree().paused and event.is_action_pressed("ui_accept"):
		await get_tree().create_timer(0.1).timeout
		# 恢复游戏状态 
		get_tree().paused = false
		# 1. 创建并播放复活动画（圆形遮罩缩小）
		var death_mask = create_respawn_mask()
		death_mask.play_expand_animation(0.5)  # 快速扩大动画
		
		# 2. 等待动画完成（同时执行其他操作）
		#await mask.animation_finished
		
		await get_tree().create_timer(1.1).timeout

		player.global_position = player.respawn_position
		player.velocity = Vector2.ZERO  # 清空速度
		player.is_dead = false  # 恢复控制
		
			  # 2. 计算目标摄像机位置（关键修改）
		var camera_x = 0 if player.respawn_position.x < 960 else 1920
			# 1. 移动摄像机到固定点
		camera2d.position = Vector2(camera_x, 0)  # Y轴固定540
		camera2d.force_update_scroll()  # 立即更新摄像机变换
		# 4. 播放放大动画（遮罩消失）
		var respawn_mask = create_respawn_mask()
		respawn_mask.play_shrink_animation(1)
		# 可选：防止事件继续传播
		get_viewport().set_input_as_handled()

# 创建复活遮罩
func create_respawn_mask():
	var mask_scene = preload("res://shader/resurrection_mask/circle_mask.tscn")
	var mask = mask_scene.instantiate()
	# 添加到场景（确保在最上层）
	get_tree().root.add_child(mask)
	
	# 设置遮罩位置为玩家位置
	var viewport = get_viewport()
	var screen_pos = viewport.get_canvas_transform().origin + player.global_position
	var normalized_center = Vector2(
		screen_pos.x / viewport.size.x * 1.77,
		screen_pos.y / viewport.size.y
	)
	print("Canvas Transform Origin:", viewport.get_canvas_transform().origin)
	# 根据玩家位置设置遮罩位置
	print(player.position)
	if player.global_position.x > 960:
		mask.position = Vector2(960, -540)  # 右侧位置
	else:
		mask.position = Vector2(-960, -540)    # 左侧位置
		
	# 设置着色器中心点
	mask.shader_material.set_shader_parameter("center", normalized_center)
	
	mask.shader_material.set_shader_parameter("radius", 2.0)
	
	return mask
