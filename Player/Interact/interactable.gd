extends StaticBody3D
class_name Interactable

signal interacted(body)

@export var can_interact : bool = true

func _interact(body):
	if can_interact:
		emit_signal("interacted", body)

func _ci_true():
	can_interact = true

func _ci_flase():
	can_interact = false
