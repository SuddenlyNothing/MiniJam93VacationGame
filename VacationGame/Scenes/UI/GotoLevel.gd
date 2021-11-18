extends ButtonSFX

export(String) var course_name : String = ""
export(int) var level_number : int = 0


func _pressed() -> void:
	Variables.load_level(course_name, level_number)
	._pressed()
