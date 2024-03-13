extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(0, 330)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.y > -350:
		position += Vector2(0, delta * -10)
	pass
