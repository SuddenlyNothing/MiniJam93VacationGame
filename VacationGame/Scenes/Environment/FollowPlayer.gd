extends Camera2D

var player


func _process(delta : float) -> void:
	if not is_instance_valid(player):
		return
	position = player.position


func set_player(p) -> void:
	position = p.position
	player = p
