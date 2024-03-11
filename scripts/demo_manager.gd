extends Node

@onready var textBubblePath = preload("res://assets/objects/ui/text_bubble.tscn")

@onready var innkeeper = $characters/innkeeper
@onready var shrouded  = $characters/shrouded
@onready var stranger1 = $characters/stranger1
@onready var stranger2 = $characters/stranger2
@onready var stranger3 = $characters/stranger3

var textOffset = Vector2(65,-45)
var destination = Vector2(-24, 5)
var demoState = 0

var textBubble

# Called when the node enters the scene tree for the first time.
func _ready():
	innkeeper.play("idle_innkeeper")
	shrouded.play("move_shrouded")
	stranger1.play("idle_stranger1")
	stranger2.play("idle_stranger2")
	stranger3.play("idle_stranger3")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match demoState:
		0:
			shrouded.position = shrouded.position.move_toward(destination, delta * 30)
			if (shrouded.position == destination):
				demoState = 1
				shrouded.play("idle_shrouded")
		1:
			print("Time to start dialog...")
			var pos = innkeeper.position + textOffset
			addTextBubble(pos)
			demoState = 2
		2: 
			pass

func addTextBubble(coord):
	textBubble = textBubblePath.instantiate()
	add_child(textBubble)
	textBubble.position = coord
	pass
	
