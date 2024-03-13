extends Node2D

var timer = 0
@onready var screenFade = $screenFade
@onready var godotScreen = $godot
@onready var title = $title

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	
	if timer > 1.0:
		screenFade.fadeIn = false
	if timer > 1.9:
		godotScreen.visible = false
	if timer > 2.3:
		screenFade.fadeIn = true
	if timer > 4:
		screenFade.fadeIn = false
	if timer > 4.5:	
		get_tree().change_scene_to_file("res://assets/scenes/demo_tavern.tscn")
