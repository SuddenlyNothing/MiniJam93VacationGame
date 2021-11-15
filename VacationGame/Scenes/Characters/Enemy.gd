extends KinematicBody2D
class_name Enemy

const DeathPoof := preload("res://Scenes/Characters/DeathPoof.tscn")

export(int) var health := 2
export(float) var knockback_friction : float = 2000.0
export(float) var knockback_force : float = 1000.0

onready var start_health := health
onready var start_pos := position
onready var flip := $Flip
onready var animated_sprite := $Flip/AnimatedSprite
onready var vision_collision := $Vision/CollisionShape2D
onready var enemy_states := $EnemyStates
onready var vision_cast := $VisionCast
onready var body_collision := $CollisionShape2D
onready var hit_flash_timer := $HitFlashTimer
onready var state_label := $StateLabel
onready var hitbox_collision := $Hitbox/CollisionShape2D
onready var reset_timer := $ResetTimer

var velocity := Vector2()
var target
var is_target_in_vision := false
var last_knockback_dir := Vector2()


func _process(delta : float) -> void:
	_set_state_label()
	_set_facing()


# Is in group resettable
func reset() -> void:
	hit_flash_timer.stop()
	animated_sprite.get_material().set_shader_param("hit_strength", 0)
	health = start_health
	position = start_pos
	reset_timer.start()
	yield(reset_timer, "timeout")
	enemy_states.call_deferred("set_state", "idle")
	velocity = Vector2()
	set_intangible(false)

# Is in group hittable.
func hit(vel : Vector2) -> void:
	if enemy_states.state == "death":
		return
	last_knockback_dir = vel.normalized()
	if health > 1:
		velocity = vel
		enemy_states.call_deferred("set_state", "knockback")
	else:
		play_death_animation()
		enemy_states.call_deferred("set_state", "death")

# Overridable function. Is called in move state.
func set_velocity(delta : float) -> void:
	pass


func apply_friction(delta : float) -> void:
	var knockback_step = knockback_friction * delta
	if velocity.length() <= knockback_step:
		velocity = Vector2()
	else:
		velocity -= velocity.normalized() * knockback_friction * delta


func move() -> void:
	velocity = move_and_slide(velocity)


func play_hit_flash() -> void:
	for i in 4:
		animated_sprite.get_material().set_shader_param("hit_strength", 1)
		hit_flash_timer.start()
		yield(hit_flash_timer, "timeout")
		animated_sprite.get_material().set_shader_param("hit_strength", 0)
		hit_flash_timer.start()
		yield(hit_flash_timer, "timeout")


func _set_facing() -> void:
	if not is_instance_valid(target):
		return
	if not target.is_inside_tree():
		return
	var x_dir : float = (target.position - position).x
	if x_dir == 0:
		return
	if sign(flip.scale.x) != sign(x_dir):
		flip.scale.x *= -1


func _on_Vision_body_entered(body) -> void:
	if not is_instance_valid(target):
		return
	if not target.is_inside_tree():
		return
	if not body == target:
		return
	is_target_in_vision = true


func _on_Vision_body_exited(body) -> void:
	if not is_instance_valid(target):
		return
	if not target.is_inside_tree():
		return
	if not body == target:
		return
	is_target_in_vision = false


func is_target_in_vision_cast() -> bool:
	if not is_instance_valid(target):
		return false
	if not target.is_inside_tree():
		return false
	if not is_target_in_vision:
		return false
	vision_cast.cast_to = target.position - position
	vision_cast.force_raycast_update()
	if vision_cast.is_colliding():
		if vision_cast.get_collider() == target:
			return true
	return false


func set_intangible(val : bool) -> void:
	visible = not val
	set_process(not val)
	set_physics_process(not val)
	body_collision.call_deferred("set_disabled", val)
	vision_collision.call_deferred("set_disabled", val)
	hitbox_collision.call_deferred("set_disabled", val)


func play_death_animation() -> void:
	var death_poof := DeathPoof.instance()
	death_poof.position = position + animated_sprite.offset
	death_poof.direction = last_knockback_dir
	get_parent().add_child(death_poof)


func play_anim(anim : String) -> void:
	if animated_sprite.animation == anim:
		return
	animated_sprite.play(anim)

# SET COLLISION MASK FOR INHERITED SCENES
func _on_Hitbox_body_entered(body):
	if body != target:
		return
	body.hit(position.direction_to(body.position) * knockback_force)


func _set_state_label() -> void:
	state_label.text = enemy_states.state
