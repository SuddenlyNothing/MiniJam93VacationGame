extends Node

# Used for input remapping and control displays
var user_keys = PoolStringArray(["pause", "shoot", "up", "left", "down", "right"])

# Used for formatting strings to display the correct key.
var input_format = {}

# Used for score keeping and knowing which level is next
# Index = level number
# ind = 0 : level scene
# ind = 1 : shots for par
# ind = 2 : score tracking
var course_data = [
	[preload("res://Scenes/Levels/L1.tscn"), 3, 0],
	[preload("res://Scenes/Levels/L2.tscn"), 5, 0],
	[preload("res://Scenes/Levels/L3.tscn"), 5, 0],
	[preload("res://Scenes/Levels/L4.tscn"), 5, 0],
	[preload("res://Scenes/Levels/L5.tscn"), 5, 0],
	[preload("res://Scenes/Levels/L6.tscn"), 6, 0],
	[preload("res://Scenes/Levels/L7.tscn"), 3, 0],
	[preload("res://Scenes/Levels/L8.tscn"), 6, 0],
]
