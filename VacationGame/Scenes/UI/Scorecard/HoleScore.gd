extends VBoxContainer

export(Color) var albatross
export(Color) var eagle
export(Color) var birdie
export(Color) var par
export(Color) var bogie
export(Color) var double_bogie
export(Color) var triple_bogie
export(Color) var quadra_bogie
export(Color) var penta_bogie

onready var hole_number_label := $HoleNumberLabel
onready var par_label := $ParLabel
onready var score_label := $ScoreLabel


func init(h_n : int, p : int, s : int) -> void:
	hole_number_label.text = str(h_n)
	
	if p == 0:
		par_label.text = "/"
	else:
		par_label.text = str(p)
	
	if s == 0:
		score_label.text = "/"
	else:
		score_label.text = str(s)
	
	if p != 0 and s != 0:
		var par_score = s - p
		match par_score:
#			-3:
#				score_label.add_color_override("font_color", albatross)
#			-2:
#				score_label.add_color_override("font_color", eagle)
#			-1:
#				score_label.add_color_override("font_color", birdie)
			0:
				score_label.add_color_override("font_color", par)
#			1:
#				score_label.add_color_override("font_color", bogie)
#			2:
#				score_label.add_color_override("font_color", double_bogie)
#			3:
#				score_label.add_color_override("font_color", triple_bogie)
#			4:
#				score_label.add_color_override("font_color", quadra_bogie)
#			5:
#				score_label.add_color_override("font_color", penta_bogie)
			_:
				if par_score > 5:
					score_label.add_color_override("font_color", penta_bogie)
				else:
					score_label.add_color_override("font_color", albatross)
