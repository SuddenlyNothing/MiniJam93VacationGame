extends CanvasLayer

export(String, FILE, "*.tscn") var menu_scene

onready var tab_container := $M/TabContainer
onready var mouse_capture := $MouseCapture
onready var press_sfx := $PressSFX
onready var menu_button := $M/TabContainer/OptionSelect/M/V/V2/H/Menu
onready var retry_button := $M/TabContainer/OptionSelect/M/V/V2/H/Retry
var active = false setget set_active

var not_level_scenes := {
	"res://Scenes/UI/MainMenu.tscn" : 0,
	"res://Scenes/UI/Credits.tscn" : 0,
	"res://Scenes/UI/LevelSelect.tscn" : 0,
}

# Toggles option menu on "pause" press
func _input(event):
	if event is InputEventKey:
		if event.is_pressed():
			for i in InputMap.get_action_list("pause"):
				if event.scancode == i.scancode:
					press_sfx.play()
					self.active = not active
					break

# Sets tab to options.
func _on_Button_pressed():
	tab_container.current_tab = 0

# Sets tab to audio settings.
func _on_Audio_pressed():
	tab_container.current_tab = 1

# Sets tab to control remapping.
func _on_Controls_pressed():
	tab_container.current_tab = 2

# Sets tab to screen settings.
func _on_ScreenSettings_pressed():
	tab_container.current_tab = 3

# Closes option menu.
func _on_Back_pressed():
	set_active(false)

# Sets the active of the option menu.
func set_active(val) -> void:
	if val:
		if Global.current_scene.filename in not_level_scenes:
			menu_button.hide()
			retry_button.hide()
	else:
		menu_button.show()
		retry_button.show()
	tab_container.current_tab = 0
	active = val
	$M.visible = val
	mouse_capture.visible = val
	get_tree().paused = val

# Closes option menu.
func _on_Menu_confirmed():
	Global.goto_scene(menu_scene)
	set_active(false)


func _on_Retry_confirmed():
	Variables.restart_level()
	set_active(false)
