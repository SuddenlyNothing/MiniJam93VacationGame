extends Node2D

const Player := preload("res://Scenes/Characters/Player.tscn")

export(String, FILE, "*.tscn") var win_screen
export(String, FILE, "*.tscn") var next_level
export(int) var level_number

onready var start_pos : Vector2 = $StartPos.position
onready var ball := $YSort/Ball
onready var hud := $HUD
onready var player_parent := $YSort
onready var death_timer := $DeathTimer
onready var next_level_timer := $NextLevelTimer
onready var holed_sfx := $HoledSFX

var player
var level_completed := false


func _ready() -> void:
	MusicPlayer.play("level")
	spawn_player()
	get_tree().call_group("needs_ball", "set_ball", ball)


#func _process(delta : float) -> void:
#	if Input.is_action_just_pressed("restart"):
#		call_deferred("spawn_player")


func _on_unwinnable() -> void:
	if death_timer.is_inside_tree():
		death_timer.start()


func spawn_player():
	if not next_level_timer.is_stopped():
		return
	death_timer.stop()
	if is_instance_valid(player):
		player.disconnect("tree_exiting", self, "_on_unwinnable")
		player.queue_free()
	player = Player.instance()
	player.connect("tree_exiting", self, "_on_unwinnable")
	player.position = start_pos
	player.hide()
	player.ball = ball
#	hud.reset_shots()
	player.connect("shot", hud, "add_shot")
	player_parent.call_deferred("add_child", player)
	get_tree().call_group("needs_player", "set_player", player)
	get_tree().call_group("resettable", "reset")
	yield(get_tree(), "idle_frame")
	player.call_deferred("show")


func _on_NextLevelTimer_timeout():
	Variables.set_current_level_score(hud.total_shots)
	Global.goto_scene(win_screen)


func _on_Flag_level_complete():
	if hud.total_shots == 0:
		spawn_player()
		return
	holed_sfx.play()
	next_level_timer.start()
