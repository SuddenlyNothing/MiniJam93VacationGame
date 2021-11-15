extends Enemy

onready var chase_sfx := $ChaseSFX
onready var hurt_sfx := $HurtSFX

var max_speed : float = 150.0
var steering : float = 5.0


func play_death_animation() -> void:
	var death_poof := DeathPoof.instance()
	death_poof.position = position + animated_sprite.offset
	death_poof.direction = last_knockback_dir
	death_poof.z_index = 120
	get_parent().add_child(death_poof)


func set_ball(b) -> void:
	target = b


func set_velocity(delta : float) -> void:
	if not is_instance_valid(target):
		return
	if not target.is_inside_tree():
		return
	velocity = lerp(velocity, position.direction_to(target.position) * max_speed,
		steering * delta)


func _on_Hitbox_body_entered(body):
	if body != target:
		return
	hitbox_collision.call_deferred("set_disabled", true)
	vision_collision.call_deferred("set_disabled", true)
	body.destroy()


func reset() -> void:
	z_index = 0
	is_target_in_vision = false
	.reset()


func is_target_in_vision_cast() -> bool:
	if not is_instance_valid(target):
		return false
	if not target.is_inside_tree():
		return false
	return is_target_in_vision
