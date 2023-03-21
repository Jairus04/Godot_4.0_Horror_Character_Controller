extends Node3D

@onready var locked_door : Node3D = get_node(NodePath(".."))
@onready var animator : AnimationPlayer = get_node(NodePath("AnimationPlayer"))
@onready var pickup_sfx : Node3D = get_node(NodePath("PickUpSfx"))

func _on_static_body_3d_interacted(_body) -> void:
	animator.play("pickup")
	locked_door.locked = false
	
func _audio_play() -> void:
	pickup_sfx.play()
	pickup_sfx.pitch_scale = randf_range(0.8, 1.2)
