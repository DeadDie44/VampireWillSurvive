extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

var attackTimer = 0

var alive = true

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("idle")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func die():
	sprite.play("death")
	alive = false
