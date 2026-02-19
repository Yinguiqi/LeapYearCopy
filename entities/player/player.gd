extends CharacterBody2D

@onready var flag_1: AnimatedSprite2D = $"../background/flag1/flag1"
@onready var flag_2: AnimatedSprite2D = $"../background/flag2/flag2"
# 移动速度
var move_speed : float = 250
# 跳跃力度
@export var jump_force := 450 
# 弹跳力度
@export var bounce_force := 550
@export var gravity := 700
@export var animator : AnimatedSprite2D
var is_dead = false 
#复活的位置坐标
var respawn_position : Vector2 = Vector2(-800,-188)
# Called every frame. 'delta' is the elapsed time since the previous frame.

# 跳跃状态枚举
enum JumpState {
	GROUNDED,       # 在地面
	RISING,         # 上升中
	FALLING,        # 下降中（未达到致命高度）
	CRITICAL_FALL,   # 致命下降中（超过128像素）
	BOUNCE          # 弹跳状态（超过256像素）
}
var jump_state: JumpState = JumpState.GROUNDED
var jump_peak_y: float = 0.0  # 记录跳跃最高点的Y坐标

func _physics_process(delta: float) -> void:
	  # 水平方向移动
	var direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	velocity.x = direction * move_speed

	# 应用重力
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		# 按住空格跳跃
		if Input.is_action_just_pressed("jump"):  # 默认空格键
			velocity.y = -jump_force

	# 移动角色（使用内置函数）
	if velocity == Vector2.ZERO:
		animator.play("idle")
	else:
		animator.play("run")
		
	if velocity.x < 0 :
		animator.flip_h = true
	else:
		animator.flip_h  = false
		
	# 跳跃状态机
	match jump_state:
		JumpState.GROUNDED:
			if Input.is_action_just_pressed("jump"):
				velocity.y = -jump_force  # 设置跳跃初速度
				jump_state = JumpState.RISING
				jump_peak_y = global_position.y

		JumpState.RISING:
			# 更新最高点位置
			if global_position.y < jump_peak_y:
				jump_peak_y = global_position.y
	
			# 检测是否开始下落
			if velocity.y >= 0:
				jump_state = JumpState.FALLING

		JumpState.FALLING:
			# 计算已下落距离
			var fall_distance = global_position.y - jump_peak_y
	
			# 检测是否超过致命高度并落地
			if fall_distance > 128 and fall_distance < 256 and is_on_floor():
				jump_state = JumpState.CRITICAL_FALL
	
			# 检测是否超过弹跳高度并落地
			if  fall_distance > 256 and is_on_floor():
				jump_state = JumpState.BOUNCE
				
			if fall_distance < 128 and is_on_floor():
				jump_state = JumpState.GROUNDED
				
		JumpState.BOUNCE:
			velocity.y = - bounce_force  # 设置弹跳初速度
			jump_peak_y = global_position.y
			jump_state = JumpState.RISING
				
		JumpState.CRITICAL_FALL:
			# 致命下落状态，执行死亡
			die()
	move_and_slide()



func _on_area_2d_area_entered(area: Area2D) -> void:
	print("检测到了物体进入：", area.name)
	if is_dead:
		return
	
	# 如果对方在 dici 分组中
	if area.is_in_group("dici") and velocity.y > 0:
		print("碰到地刺，死亡")
		die()
		
	if area.name == "flag2":
		respawn_position = area.global_position
		save_player_config()
		flag_2.visible = true
		flag_1.visible = false

		

func die():
	is_dead = true
	get_tree().paused = true  # 暂停游戏
	AudioManager.play_sfx("Death")
	jump_state = JumpState.GROUNDED

func load_player_config(config: ConfigFile) -> void:
	var x = config.get_value("player", "respawn_x", -800)
	var y = config.get_value("player", "respawn_y", -188)
	respawn_position = Vector2(x, y)	
	position = respawn_position
	
func save_player_config() -> void:
	var config := ConfigFile.new()

	config.set_value("player", "respawn_x", respawn_position.x)
	config.set_value("player", "respawn_y", respawn_position.y)
	config.save(Menu.CONFIG_PATH)
	
