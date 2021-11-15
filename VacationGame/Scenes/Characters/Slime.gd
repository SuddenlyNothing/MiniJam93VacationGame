extends Enemy

onready var step_sfx := $StepSFX
onready var hurt_sfx := $HurtSFX

var move_speed := 150.0


func set_player(p) -> void:
	target = p


func set_velocity(_delta : float) -> void:
	if not is_instance_valid(target):
		enemy_states.call_deferred("set_state", "idle")
		return
	if not target.is_inside_tree():
		enemy_states.call_deferred("set_state", "idle")
		return
	velocity = position.direction_to(target.position) * move_speed


func _on_AnimatedSprite_frame_changed():
	if animated_sprite.animation == "chase":
		match animated_sprite.frame:
			0:
				hitbox_collision.call_deferred("set_disabled", false)
			1:
				hitbox_collision.call_deferred("set_disabled", true)
			2:
				hitbox_collision.call_deferred("set_disabled", false)
			3:
				hitbox_collision.call_deferred("set_disabled", true)
				step_sfx.play()
	else:
		hitbox_collision.call_deferred("set_disabled", true)


func hit(vel: Vector2) -> void:
	hurt_sfx.play()
	.hit(vel)


func drown() -> void:
	enemy_states.call_deferred("set_state", "death")
