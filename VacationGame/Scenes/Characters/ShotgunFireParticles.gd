extends Node2D

onready var shotgun_fire_particles := $ShotgunFireParticles
onready var queue_timer := $QueueTimer
onready var animated_sprite := $AnimatedSprite


func _ready() -> void:
	shotgun_fire_particles.set_emitting(true)
	queue_timer.start(shotgun_fire_particles.lifetime)
	animated_sprite.play("fire")
