extends CanvasLayer

onready var shots := $M/H/Shots
onready var par := $M/H/Par

var total_shots : int = 0


func _ready() -> void:
	if Variables.current_course != "":
		par.text = " Par " + str(Variables.get_level_par()) + " "


func add_shot() -> void:
	total_shots += 1
	shots.text = " " + str(total_shots) + " "
