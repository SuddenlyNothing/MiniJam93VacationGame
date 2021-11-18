extends Control

const HoleScore := preload("res://Scenes/UI/Scorecard/HoleScore.tscn")

onready var scores := $M/V/H/Scores
onready var par_total_label := $M/V/H/Total/ParTotalLabel
onready var score_total_label := $M/V/H/Total/ScoreTotalLabel


func _ready() -> void:
	_init_scorecard()

# Initializes the scorecard with information based on the Variables singleton
func _init_scorecard() -> void:
	var scorecard_size : int = Variables.scorecard.size()
	scores.size_flags_stretch_ratio = scorecard_size
	var score_total : int = 0
	var par_total : int = 0
	for i in range(scorecard_size):
		var par : int
		var score : int = Variables.scorecard[i]
		score_total += score
		if score != 0 or i + 1 > Variables.current_level:
			par = Variables[Variables.current_course].par[i]
			par_total += par
		else:
			par = 0
		var hole_score := HoleScore.instance()
		scores.add_child(hole_score)
		hole_score.init(i + 1, par, score)
	par_total_label.text = str(par_total)
	score_total_label.text = str(score_total)
