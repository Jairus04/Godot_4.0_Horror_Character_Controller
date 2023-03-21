extends Node3D

@export var fast_close : bool = true

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if !OS.is_debug_build():
		fast_close = false
	
	if fast_close:
		print("** Fast Close enabled in the 'L_Main.gd' script **")
		print("** 'Esc' to close 'Shift + F1' to release mouse **")
	
	set_process_input(fast_close)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"change_mouse_input"):
		match Input.get_mouse_mode():
			Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
