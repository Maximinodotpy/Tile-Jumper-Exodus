extends Node

var levels = null

func _ready():
	var file = FileAccess.open('res://Scenes/Userinterfaces/levels.json', FileAccess.READ)
	levels = JSON.parse_string(file.get_as_text())

