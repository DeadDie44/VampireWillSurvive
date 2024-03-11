extends Node2D

var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if (timer > 1):
		get_tree().change_scene_to_file("res://assets/scenes/demo_tavern.tscn")
