extends CharacterBody3D
class_name CharacterController

signal stepped

@export_group("FUNCTIONAL OPTIONS")
@export var can_move : bool = true
@export var can_headbob : bool = true
@export var can_use_torch : bool = true

@export_group("MOVEMENT PARAMETERS")
@export var speed : float = 2.0
@export var acceleration : float = 8.0
@export var deceleration : float = 10.0
@export var gravity_multiplier : float = 3.0
@export_range (0.0, 1.0, 0.05) var air_control : float = 0.3

@export_group("TORCH PARAMETERS")
@export var click_audios: Array[AudioStream]
@export var torch_sway_speed : float = 15.0

@onready var gravity : float = (ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_multiplier)
@onready var camera_holder : Node3D = get_node(NodePath("CameraHolder"))
@onready var torchloc : Node3D = get_node(NodePath("TorchHolder/Torchloc"))
@onready var torch : Node3D = get_node(NodePath("TorchHolder/Torch"))
@onready var torch_light : Node3D = get_node(NodePath("TorchHolder/Torch/TorchLight"))
@onready var headbob_animation : AnimationPlayer = get_node(NodePath("AnimationPlayers/HeadbobAnimation"))
@onready var torch_timer : Timer = get_node(NodePath("Timers/TorchTimer"))
@onready var torch_click_sfx : AudioStreamPlayer3D = get_node(NodePath("PlayerAudios/TorchClickSfx"))
@onready var pause_menu : ColorRect = get_node(NodePath("PauseMenu"))

var direction := Vector3()
var input_axis := Vector2()

func _physics_process(delta: float) -> void:
	input_axis = Input.get_vector(&"move_back", &"move_forward", &"move_left", &"move_right")
	_direction_input()
	
	if not is_on_floor(): velocity.y -= gravity * delta
	if direction != Vector3() and can_headbob: headbob_animation.play("walk_headbob")
	
	torch.global_transform.origin = torchloc.global_transform.origin
	torch.rotation.y = lerp_angle(torch.rotation.y, rotation.y, torch_sway_speed * delta)
	torch.rotation.x = lerp_angle(torch.rotation.x, camera_holder.rotation.x, torch_sway_speed * delta)
	
	_accelerate(delta)
	move_and_slide()

func _input(_event: InputEvent) -> void:
	if can_use_torch:
		if Input.is_action_just_pressed("toggle_torch") and torch_light.visible == false and torch_timer.is_stopped():
			torch_light.show()
			torch_timer.start()
			torch_click_sfx.stream = random_torch_click()
			torch_click_sfx.play()
		elif Input.is_action_just_pressed("toggle_torch") and torch_light.visible == true and torch_timer.is_stopped():
			torch_light.hide()
			torch_timer.start()
			torch_click_sfx.stream = random_torch_click()
			torch_click_sfx.play()
		torch.visible = true
	else :
		torch.visible = false
	
	if _event.is_action_pressed("ui_cancel"):
		pause_menu._pause()

func _direction_input() -> void:
	var aim : Basis = get_global_transform().basis
	direction = Vector3()
	direction = aim.z * -input_axis.x + aim.x * input_axis.y

func _accelerate(delta: float) -> void:
	var target : Vector3 = direction * speed
	var temp_vel := velocity
	var temp_accel : float
	temp_vel.y = 0
	
	if direction.dot(temp_vel) > 0: temp_accel = acceleration
	else: temp_accel = deceleration
	
	if not is_on_floor(): temp_accel *= air_control
	
	temp_vel = temp_vel.lerp(target, temp_accel * delta)
	velocity.x = temp_vel.x
	velocity.z = temp_vel.z

func _step(_is_on_floor:bool) -> bool:
	if (is_on_floor):
		emit_signal("stepped")
		return true
	return false

func random_torch_click() -> AudioStream:
	return click_audios[randi() % click_audios.size()]
