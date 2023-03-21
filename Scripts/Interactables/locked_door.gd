extends Node3D

@export var locked : bool = true
@export var animator : AnimationPlayer
@export var door_open_sfx : AudioStreamPlayer3D
@export var door_close_sfx : AudioStreamPlayer3D
@export var locked_door_sfx : AudioStreamPlayer3D
@export var door_unlokced_sfx : AudioStreamPlayer3D

var door_lock_check : bool = true
var open : bool = true

func _on_door_interacted(_body) -> void:
	if locked == false:
		animator.play("unlocked")
	elif locked == true:
		animator.play("locked")
	
	if not door_lock_check:
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

func _locked_door_play() -> void:
	locked_door_sfx.play()
	locked_door_sfx.pitch_scale = randf_range(0.8, 1.2)

func _door_unlocked_play() -> void:
	door_unlokced_sfx.play()
	door_unlokced_sfx.pitch_scale = randf_range(0.8, 1.2)

func _dlc_false() -> void:
	door_lock_check = false
