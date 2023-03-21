extends Node3D

@export_group("FUNCTIONAL OPTIONS")
@export var can_look : bool = true
@export var can_cam_tilt : bool = true
@export var can_zoom : bool = true

@export_group("LOOK PARAMETERS")
@export_node_path("MovementController") var controller_path := NodePath("../")
@export_node_path("Camera3D") var cam_path := NodePath("../MainCamera")
@export var mouse_sensitivity : float = 2.0
@export var y_limit : float = 70.0

@export_group("TILT PARAMETERS")
@export var camera_tilt_amount : float = 0.02
@export var camera_tilt_speed : float = 0.1
@export var camera_tilt_damping : float = 0.3

@export_group("ZOOM PARAMETERS")
@export var zoom_fov_multiplier : float = 0.7
@export var zoom_speed : float = 5.0

@onready var cam: Camera3D = get_node(cam_path)
@onready var camera_tilt : CameraTilt = get_node(NodePath("CameraTilt"))
@onready var controller : CharacterController = get_node(controller_path)
@onready var normal_speed : float = controller.speed
@onready var normal_fov : float = cam.fov

var mouse_axis := Vector2()
var rot := Vector3()

func _ready() -> void:
	mouse_sensitivity = mouse_sensitivity / 1000
	y_limit = deg_to_rad(y_limit)
	
	_start_variables()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_axis = event.relative
		_camera_rotation()

func _physics_process(delta: float) -> void:
	var joystick_axis := Input.get_vector(&"look_left", &"look_right", &"look_down", &"look_up")
	
	if joystick_axis != Vector2.ZERO:
		mouse_axis = joystick_axis * 1000.0 * delta
		_camera_rotation()
	
	if can_zoom:
		_zoom(delta)

func _camera_rotation() -> void:
	if can_look:
		rot.y -= mouse_axis.x * mouse_sensitivity
		rot.x = clamp(rot.x - mouse_axis.y * mouse_sensitivity, -y_limit, y_limit)
		
		get_owner().rotation.y = rot.y
		rotation.x = rot.x

func _zoom(delta: float) -> void:
	if _check_zoom():
		cam.set_fov(lerp(cam.fov, normal_fov * zoom_fov_multiplier, delta * zoom_speed))
	else:
		cam.set_fov(lerp(cam.fov, normal_fov, delta * zoom_speed))

func _check_zoom() -> bool:
	return (Input.is_action_pressed(&"zoom"))

func _start_variables():
	camera_tilt.can_cam_tilt = can_cam_tilt
	camera_tilt.camera_tilt_amount = camera_tilt_amount
	camera_tilt.camera_tilt_speed = camera_tilt_speed
	camera_tilt.camera_tilt_damping = camera_tilt_damping
