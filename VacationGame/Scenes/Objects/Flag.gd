extends Area2D

signal level_complete


func _on_Flag_body_entered(body):
	if not body.is_in_group("ball"):
		return
	body.set_intangible(true)
	emit_signal("level_complete")
