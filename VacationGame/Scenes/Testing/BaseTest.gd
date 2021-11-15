extends Node2D

const Player := preload("res://Scenes/Characters/Player.tscn")

onready var player_parent := $YSort
onready var start_pos : Vector2 = $StartPos.position
onready var death_timer := $DeathTimer
onready var ball := $YSort/Ball
onready var hud := $HUD

var player


func _ready() -> void:
	spawn_player()


func _on_player_death() -> void:
	if death_timer.is_inside_tree():
		death_timer.start()


func spawn_player():
	player = Player.instance()
	player.connect("tree_exiting", self, "_on_player_death")
	player.position = start_pos
	player.hide()
	player.ball = ball
	player.connect("shot", hud, "add_shot")
	player_parent.call_deferred("add_child", player)
	get_tree().call_group("needs_player", "set_player", player)
	get_tree().call_group("resettable", "reset")
	player.call_deferred("show")
