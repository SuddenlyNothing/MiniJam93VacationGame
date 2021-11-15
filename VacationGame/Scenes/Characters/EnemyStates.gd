extends StateMachine
class_name EnemyStates

func _ready() -> void:
	add_state("idle")
	add_state("chase")
	add_state("knockback")
	add_state("death")
	call_deferred("set_state", "idle")

# Contains state logic.
func _state_logic(delta : float) -> void:
	match state:
		states.idle:
			pass
		states.chase:
			parent.move()
			parent.set_velocity(delta)
		states.knockback:
			parent.move()
			parent.apply_friction(delta)
		states.death:
			pass

# Return value will be used to change state.
func _get_transition(delta : float):
	match state:
		states.idle:
			if parent.is_target_in_vision_cast():
				return states.chase
		states.chase:
			pass
		states.knockback:
			if parent.velocity == Vector2():
				if parent.health > 0:
					return states.chase
				else:
					return states.death
		states.death:
			pass
	return null

# Called on entering state.
# new_state is the state being entered.
# old_state is the state being exited.
func _enter_state(new_state : String, old_state) -> void:
	match new_state:
		states.idle:
			parent.play_anim("idle")
		states.chase:
			parent.play_anim("chase")
		states.knockback:
			parent.play_anim("knockback")
			parent.play_hit_flash()
			parent.health -= 1
		states.death:
			parent.play_anim("knockback")
			parent.set_intangible(true)
			set_physics_process(false)

# Called on exiting state.
# old_state is the state being exited.
# new_state is the state being entered.
func _exit_state(old_state : String, new_state : String) -> void:
	match old_state:
		states.idle:
			pass
		states.chase:
			pass
		states.knockback:
			pass
		states.death:
			parent.set_intangible(false)
			set_physics_process(true)
