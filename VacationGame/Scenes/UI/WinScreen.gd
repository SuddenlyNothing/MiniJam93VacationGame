extends Control

export(String, FILE, "*.tscn") var credits

onready var current_level := $V/V/CurrentLevel
onready var next_level := $V/V2/NextLevel
onready var retry := $V/V2/Retry
onready var shots := $V/V/Shots
onready var background := $Background
onready var menu := $V/V2/Menu

var background_speed : float = 20.0


func _process(delta : float) -> void:
	background.region_rect.position += Vector2.ONE * background_speed * delta

# Current level
# Current level number
# Next level
# Total shots
func init(args : Dictionary):
	current_level.text = "Level " + str(args["current_level_number"]) + " Completed!"
	shots.text = "Shots: " + str(args["shots"])
	if args["next_level"] == "":
		next_level.hide()
		menu.next_scene = credits
	else:
		next_level.next_scene = args["next_level"]
	retry.next_scene = args["current_level"]
