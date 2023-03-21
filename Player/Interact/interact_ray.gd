extends RayCast3D

@onready var c_dot : TextureRect = get_node(NodePath("Crosshairs/Dot"))

func _ready() -> void:
	add_exception(owner)
	c_dot.hide()

func _physics_process(_delta: float) -> void:
	if is_colliding():
		var detected = get_collider()
		
		if detected is Interactable:
			c_dot.show()
			if Input.is_action_just_pressed("interact"):
				detected._interact(owner)
		else:
			c_dot.hide()
	else:
		c_dot.hide()
