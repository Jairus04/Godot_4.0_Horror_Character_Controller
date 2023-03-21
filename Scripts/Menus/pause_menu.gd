extends ColorRect

@onready var animator : AnimationPlayer = get_node(NodePath("AnimationPlayer"))
@onready var timer_label : Label = get_node(NodePath("MarginContainer/VBoxContainer/TimerLabel"))
@onready var continue_button : Button = get_node(NodePath("MarginContainer/VBoxContainer/ContinueBtn"))
@onready var options_button : Button = get_node(NodePath("MarginContainer/VBoxContainer/OptionsBtn"))
@onready var extra_button : Button = get_node(NodePath("MarginContainer/VBoxContainer/ExtraBtn"))
@onready var quit_button : Button = get_node(NodePath("MarginContainer/VBoxContainer/QuitBtn"))

var time : float = 0.0
var timer_on : bool = true

func  _ready() -> void:
	continue_button.pressed.connect(_unpause)
	quit_button.pressed.connect(get_tree().quit)

func _process(delta: float) -> void:
	if (timer_on):
		time += delta
	
	var secs = fmod(time, 60)
	var mins = fmod(time, 60 * 60) / 60
	var hrs = fmod(fmod(time, 3600 * 60) / 3600, 24)
	
	var time_passed = "%02d:%02d:%02d" % [hrs,mins,secs]
	timer_label.text = time_passed

func _unpause() -> void:
	animator.play("unpause")
	get_tree().paused = false
	timer_on = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _pause() -> void:
	animator.play("pause")
	get_tree().paused = true
	timer_on = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
