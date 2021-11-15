extends CPUParticles2D

onready var free_timer := $FreeTimer


func _ready() -> void:
	emitting = true
	free_timer.start(lifetime)
