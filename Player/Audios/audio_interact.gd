extends Resource
class_name AudioInteract

@export var step_audios: Array[AudioStream]

func random_step() -> AudioStream:
	return step_audios[randi() % step_audios.size()]
