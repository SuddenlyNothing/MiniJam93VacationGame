extends AnimatedSprite


func _ready() -> void:
	play("splash")


func _on_SplashSFX_finished():
	queue_free()


func reset() -> void:
	queue_free()
