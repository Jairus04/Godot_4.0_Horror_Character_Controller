extends Node3D
class_name CameraTilt

@export var can_cam_tilt : bool = true
@export var camera_tilt_amount : float = 0.02
@export var camera_tilt_speed : float = 0.2
@export var camera_tilt_damping : float = 0.3

var target_tilt_angle: float = 0.0

func _physics_process(_delta):
	if can_cam_tilt:
		if Input.is_action_pressed(&"move_left"): target_tilt_angle += deg_to_rad(camera_tilt_speed)
		if Input.is_action_pressed(&"move_right"): target_tilt_angle -= deg_to_rad(camera_tilt_speed)
		
		if not Input.is_action_pressed(&"move_left") and self.rotation.z > 0: target_tilt_angle -= deg_to_rad(camera_tilt_speed * camera_tilt_damping)
		if not Input.is_action_pressed(&"move_right") and self.rotation.z < 0: target_tilt_angle += deg_to_rad(camera_tilt_speed * camera_tilt_damping)
		
		target_tilt_angle = clamp(target_tilt_angle, -camera_tilt_amount, camera_tilt_amount)
		self.rotation.z = lerp(self.rotation.z, target_tilt_angle, camera_tilt_damping)
