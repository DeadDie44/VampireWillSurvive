extends Node2D

@onready var button = $Button

func _ready():
	button.pressed.connect(goToTitleScreen)
	button.position = Vector2(520,320)

func goToTitleScreen():
	get_tree().change_scene_to_file("res://assets/scenes/start.tscn")
