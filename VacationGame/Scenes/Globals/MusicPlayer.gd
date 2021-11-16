extends Node


onready var ambient_music := $AmbientMusic
onready var nature_loop := $NatureLoop
onready var water_loop := $WaterLoop
onready var menu_loop := $MenuLoop

var num_lowers : int = 0
var current : String = ""


func play(song : String) -> void:
	if song == current:
		return
	stop_all()
	match song:
		"level":
			ambient_music.play()
			nature_loop.play()
			water_loop.play()
		"menu":
			menu_loop.play()
	current = song


func stop_all() -> void:
	for child in get_children():
		child.stop()


func lower_volume() -> void:
	if num_lowers == 0:
		for child in get_children():
			child.volume_db -= 5
	num_lowers += 1


func increase_volume() -> void:
	if num_lowers == 1:
		for child in get_children():
			child.volume_db += 5
	num_lowers -= 1
