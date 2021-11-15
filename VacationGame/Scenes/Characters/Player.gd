extends KinematicBody2D

const ShotgunFireParticles := preload("res://Scenes/Characters/ShotgunFireParticles.tscn")
const DeathPoof := preload("res://Scenes/Characters/DeathPoof.tscn")

signal shot

onready var hand := $YSort/Hand
onready var body := $YSort/Body
onready var animation_player := $AnimationPlayer
onready var shoot_timer := $ShootTimer
onready var t := $Tween
onready var shotgun_collision := $YSort/Hand/ShotgunHitbox/CollisionPolygon2D
onready var shotgun_hitbox := $YSort/Hand/ShotgunHitbox
onready var gun_point := $YSort/Hand/GunPoint
onready var ysort := $YSort
onready var hit_flash_timer := $HitFlashTimer
onready var shotgun_sfx := $ShotgunSFX

var hand_offset := Vector2(20.0, 10.0)
var gun_offset := Vector2(0, 39.5)
var knockback : float = 900.0
var input : Vector2 = Vector2()
var move_speed : float = 300.0
var ball
var health : int = 2
var knockback_velocity := Vector2()
var knockback_friction : float = 3000.0


func _process(delta : float) -> void:
	_shoot()
	_set_facing()
	_set_hand_rot()
	_set_input()


func move(delta : float) -> void:
	move_and_slide(input.normalized() * move_speed)
	if knockback_velocity != Vector2():
		apply_knockback()
		apply_knockback_friction(delta)


func _set_hand_rot() -> void:
	if not is_instance_valid(ball):
		return
	if not ball.is_inside_tree():
		return
	var aim_dir : Vector2 = (ball.position - shotgun_hitbox.global_position).normalized()
	hand.flip_v = aim_dir.x < 0
	if aim_dir.x < 0:
		hand.offset.y = -6
	else:
		hand.offset.y = 6
	hand.position = aim_dir * hand_offset
	hand.rotation = aim_dir.angle()


func _set_facing() -> void:
	if not is_instance_valid(ball):
		return
	if not ball.is_inside_tree():
		return
	var face_dir : float = ball.position.x - position.x
	if face_dir == 0:
		return
	if sign(face_dir) != sign(body.scale.x):
		body.scale.x *= -1


func _set_input() -> void:
	input = Vector2()
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y = Input.get_action_strength("down") - Input.get_action_strength("up")


func play_anim(anim : String) -> void:
	if animation_player.current_animation == anim:
		return
	animation_player.play(anim)


func _play_shoot_anims() -> void:
	var shotgun_fire_particles := ShotgunFireParticles.instance()
	shotgun_fire_particles.position = gun_point.global_position
	shotgun_fire_particles.rotation = hand.rotation
	get_parent().add_child(shotgun_fire_particles)
	shoot_timer.start()
	t.interpolate_property(hand, "offset:x", 0, 31, 0.3)
	t.start()


func _shoot() -> void:
	if not (Input.is_action_just_pressed("shoot") and shoot_timer.is_stopped()):
		return
	shotgun_sfx.play()
	emit_signal("shot")
	shoot_timer.start()
	_play_shoot_anims()
	for i in shotgun_hitbox.get_overlapping_bodies():
		if i.is_in_group("hittable"):
			i.hit((ball.position - shotgun_hitbox.global_position)\
				.normalized() * knockback)


func drown() -> void:
	queue_free()


func hit(vel : Vector2) -> void:
	health -= 1
	var sfx := AudioStreamPlayer.new()
	sfx.stream = preload("res://Assets/SFX/Hurt.wav")
	sfx.bus = "SFX"
	get_parent().add_child(sfx)
	sfx.play()
	sfx.connect("finished", sfx, "queue_free")
	if health <= 0:
		var death_poof := DeathPoof.instance()
		death_poof.position = position + ysort.position
		death_poof.direction = vel.normalized()
		get_parent().add_child(death_poof)
		queue_free()
	else:
		play_hit_flash()
		knockback_velocity = vel


func play_hit_flash() -> void:
	for i in 3:
		ysort.get_material().set_shader_param("hit_strength", 1)
		hit_flash_timer.start()
		yield(hit_flash_timer, "timeout")
		ysort.get_material().set_shader_param("hit_strength", 0)
		hit_flash_timer.start()
		yield(hit_flash_timer, "timeout")


func apply_knockback() -> void:
	move_and_slide(knockback_velocity)
	if get_slide_count() > 0:
		knockback_velocity = Vector2()


func apply_knockback_friction(delta : float) -> void:
	var friction_step = knockback_friction * delta
	if friction_step >= knockback_velocity.length():
		knockback_velocity = Vector2()
	else:
		knockback_velocity -= knockback_velocity.normalized() * friction_step
