extends ButtonSFX

signal confirmed

var popup_active := false setget set_popup_active

onready var t := $Tween
onready var popup := $CL/M/Popup
onready var m := $CL/M


func _pressed() -> void:
	set_popup_active(true)
	._pressed()


func _on_M_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if popup_active:
				set_popup_active(false)


func set_popup_active(active : bool) -> void:
	popup_active = active
	t.remove_all()
	if active:
		m.show()
		t.interpolate_property(popup, "rect_scale", Vector2(), Vector2.ONE, 0.3,
				Tween.TRANS_BACK, Tween.EASE_OUT)
		t.start()
	else:
		._pressed()
		t.interpolate_property(popup, "rect_scale", Vector2.ONE, Vector2(), 0.1)
		t.start()


func _on_Tween_tween_all_completed():
	if not popup_active:
		m.hide()


func _on_Ok_pressed():
	emit_signal("confirmed")
	set_popup_active(false)


func _on_Cancel_pressed():
	set_popup_active(false)
