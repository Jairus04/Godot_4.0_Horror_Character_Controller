extends Node3D
class_name PlayerAudios

@onready var step_stream : AudioStreamPlayer3D = get_node(NodePath("FootstepSfx"))
@onready var raycast : RayCast3D = get_node(NodePath("GroundCheck"))
@onready var character_body : CharacterBody3D = get_node(NodePath(".."))
@onready var character_controller : CharacterController = get_node(NodePath(".."))

@export var audio_interact : Resource
@export var physic_materials : Array[PhysicsMaterial]
@export var audio_interacts : Array[Resource]

func _ready() -> void:
	pass
	character_controller.stepped.connect(_on_controller_stepped.bind())

func _on_controller_stepped():
	var collision = raycast.get_collider()
	_get_audio_interact_of_object(collision)
	step_stream.stream = audio_interact.random_step()
	step_stream.play()
	step_stream.pitch_scale = randf_range(0.8, 1.2)

func _get_audio_interact():
	var k_col = character_body.get_last_slide_collision()
	var collision = k_col.get_collider(0)
	_get_audio_interact_of_object(collision)

func _get_audio_interact_of_object(collision):
	var mat = collision.physics_material_override
	if !collision:
		return
	if not "physics_material_override" in collision:
		return
	if mat:
		var i = physic_materials.rfind(mat)
		if i != -1:
			audio_interact = audio_interacts[i]
