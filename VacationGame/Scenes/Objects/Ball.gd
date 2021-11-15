extends KinematicBody2D

signal reset_level

onready var arrow := $Arrow
onready var line := $Line2D
onready var detect_shotgun_collision := $DetectShotgun/CollisionShape2D
onready var start_pos := position
onready var body_collision := $CollisionShape2D
onready var bounce_sfx := $BounceSFX
onready var reset_timer := $ResetTimer

var velocity := Vector2()
var player
var friction : float = 440.0


func _process(delta : float) -> void:
	_set_arrow()


func _physics_process(delta : float) -> void:
	_move(delta)
	_apply_friction(delta)


func _set_arrow() -> void:
	if not is_instance_valid(player):
		return
	var dir_preview : Vector2 = (position - player.shotgun_hitbox.global_position)\
		.normalized() * 200
	arrow.rotation = dir_preview.angle()
	arrow.position = dir_preview
	line.points[1] = dir_preview


func _set_arrow_show(is_show : bool) -> void:
	arrow.visible = is_show
	line.visible = is_show


func set_player(p) -> void:
	player = p


func _on_Area2D_area_entered(area : Area2D) -> void:
	if not area.is_in_group("shotgun_hitbox"):
		return
	_set_arrow_show(true)


func _on_Area2D_area_exited(area : Area2D) -> void:
	if not area.is_in_group("shotgun_hitbox"):
		return
	_set_arrow_show(false)


func _apply_friction(delta : float) -> void:
	var friction_step = friction * delta
	if velocity.length() <= friction_step:
		velocity = Vector2()
	else:
		velocity -= velocity.normalized() * friction * delta


func _move(delta : float) -> void:
	detect_shotgun_collision.call_deferred("set_disabled", velocity != Vector2())
	var collision := move_and_collide(velocity * delta)
	if collision:
		bounce_sfx.play()
		velocity = velocity.bounce(collision.normal)


func hit(vel : Vector2) -> void:
	velocity += vel


func reset() -> void:
	velocity = Vector2()
	position = start_pos
	reset_timer.start()
	yield(reset_timer, "timeout")
	set_intangible(false)


func set_intangible(val : bool) -> void:
	if val:
		velocity = Vector2()
	detect_shotgun_collision.call_deferred("set_disabled", val)
	body_collision.call_deferred("set_disabled", val)
	set_process(not val)
	set_physics_process(not val)
	visible = not val


func drown() -> void:
	destroy()


func destroy() -> void:
	emit_signal("reset_level")
	set_intangible(true)
