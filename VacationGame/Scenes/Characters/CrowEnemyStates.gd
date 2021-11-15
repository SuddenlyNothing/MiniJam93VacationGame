extends EnemyStates


func _enter_state(new_state : String, old_state) -> void:
	match new_state:
		states.chase:
			parent.chase_sfx.play()
			parent.z_index = 110
			parent.hitbox_collision.call_deferred("set_disabled", false)
		states.knockback:
			parent.hurt_sfx.play()
			parent.hitbox_collision.call_deferred("set_disabled", true)
			parent.z_index = 110
	._enter_state(new_state, old_state)


func _exit_state(old_state : String, new_state : String) -> void:
	match old_state:
		states.chase:
			parent.chase_sfx.stop()
		states.knockback:
			parent.hurt_sfx.stop()
	._exit_state(old_state, new_state)
