extends Node3D

@export var animator : AnimationPlayer
@export var door_open_sfx : AudioStreamPlayer3D
@export var door_close_sfx : AudioStreamPlayer3D
@export var door_close_trigger : Area3D

var open : bool = true

func _on_door_interacted(_body) -> void:
	if open == true:
		animator.play("open")
		open = false
	
	elif open == false:
		animator.play("close")
		open = true

func _audio_open_play() -> void:
	door_open_sfx.play()
	door_open_sfx.pitch_scale = randf_range(0.8, 1.2)

func _audio_close_play() -> void:
	door_close_sfx.play()
	door_close_sfx.pitch_scale = randf_range(0.8, 1.2)

func _on_door_close_trigger_body_entered(_body: Node3D) -> void:
	animator.play("close")
	door_close_trigger.queue_free()
