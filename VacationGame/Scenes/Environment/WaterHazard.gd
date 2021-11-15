extends Area2D

const Splash := preload("res://Scenes/Environment/Splash.tscn")

onready var clear_exceptions_timer := $ClearExceptionsTimer

var exceptions := {}


func _on_WaterHazard_body_entered(body):
	if body in exceptions:
		return
	if not body.is_in_group("drownable"):
		return
	exceptions[body] = 1
	var splash := Splash.instance()
	splash.position = body.position
	get_parent().add_child(splash)
	body.drown()
	clear_exceptions_timer.start()
	


func clear_exceptions():
	exceptions.clear()
