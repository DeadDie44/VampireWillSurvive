extends Node2D

@onready var blackScreen = $Sprite2D
var fadeIn = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fadeIn:
		set_modulate(lerp(get_modulate(), Color(1,1,1,0), 0.02))
	else:
		set_modulate(lerp(get_modulate(), Color(0,0,0,1), 0.02))
