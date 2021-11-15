extends Control


func _ready():
	MusicPlayer.play("menu")


func _on_Settings_pressed():
	OptionsMenu.set_active(true)
