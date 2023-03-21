extends OmniLight3D

@export var click_audios: Array[AudioStream]
@export var light_bulb : MeshInstance3D

@onready var switch_sfx : AudioStreamPlayer3D = get_node(NodePath("../../SwitchSfx"))
var player = null

func _on_button_interacted(_body) -> void:
	var light_mat = light_bulb.material_override
	
	if self.visible == false:
		self.visible = true
		_play_switch_sfx()
		light_mat.emission_enabled = true
	
	elif self.visible == true:
		self.visible = false
		_play_switch_sfx()
		light_mat.emission_enabled = false

func _play_switch_sfx() -> void:
	switch_sfx.stream = random_audio_switch()
	switch_sfx.play()
	switch_sfx.pitch_scale = randf_range(0.8, 1.2)

func random_audio_switch() -> AudioStream:
	return click_audios[randi() % click_audios.size()]
