extends CanvasLayer

onready var shots := $M/H/Shots

var total_shots : int = 0


func add_shot() -> void:
	total_shots += 1
	shots.text = str(total_shots)


func reset_shots() -> void:
	total_shots = 0
	shots.text = str(total_shots)
