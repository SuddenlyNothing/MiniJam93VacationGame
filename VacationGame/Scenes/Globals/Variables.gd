extends Node

# Used for input remapping and control displays
var user_keys = PoolStringArray(["pause", "shoot", "up", "left", "down", "right"])

# Used for formatting strings to display the correct key.
var input_format = {}

# used for loading levels in the easy_course
const easy_course = {
	"prefix" : "res://Scenes/Levels/L{level_number}.tscn",
	"par" : [
		3,
		5,
		5,
		4,
		4,
		6,
		3,
		6,
	],
}

# used for keeping track of score
var scorecard : Array = []
var current_course : String = ""
var current_level : int = -1
var previous_scores : int = 0


func load_level(course_name : String, level_number : int) -> void:
	current_course = course_name
	current_level = level_number
	scorecard.clear()
	for i in self[course_name].par:
		scorecard.append(0)
	var next_level = self[course_name].prefix.format({"level_number":level_number})
	Global.goto_scene(next_level)


func clear_scorecard() -> void:
	scorecard.clear()


func set_current_level_score(score : int) -> void:
	scorecard[current_level - 1] = score


func load_next_level() -> void:
	current_level += 1
	previous_scores += scorecard[current_level - 1]
	var next_level = self[current_course].prefix.format({"level_number":current_level})
	Global.goto_scene(next_level)


func get_previous_score_total() -> int:
	return previous_scores


func has_next_level() -> bool:
	if current_course == "" or current_level == -1:
		return false
	if self[current_course].par.size() <= current_level:
		return false
	return true
