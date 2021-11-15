extends Control


func _ready() -> void:
	MusicPlayer.play("menu")


func _on_ItchLink_pressed():
	OS.shell_open("https://n-thing.itch.io/")
