extends Control

export(String, FILE, "*.tscn") var main_menu

onready var next_hole := $NextHole
onready var menu := $Menu
onready var menu2 := $Menu2


func _ready() -> void:
	if not Variables.has_next_level():
		next_hole.hide()
		menu.hide()
		menu2.show()
	MusicPlayer.lower_volume()


func _on_WinSong_tree_exited():
	MusicPlayer.increase_volume()


func _on_Retry_confirmed():
	Variables.restart_level()


func _on_Menu_confirmed():
	Global.goto_scene(main_menu)


func _on_NextHole_pressed():
	Variables.load_next_level()
