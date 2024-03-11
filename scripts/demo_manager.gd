extends Node

@onready var textBubblePath = preload("res://assets/objects/ui/text_bubble.tscn")

@onready var innkeeper = $characters/innkeeper
@onready var shrouded  = $characters/shrouded
@onready var stranger1 = $characters/stranger1
@onready var stranger2 = $characters/stranger2
@onready var stranger3 = $characters/stranger3

@onready var actorArray = [innkeeper, shrouded, stranger3]

var textOffset = Vector2(65,-45)
var destination = Vector2(-24, 5)
var demoState = 0
var dialogProgress = 0


var textArray = [
	#longest message should be about this long:
	#"The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown"
	["Hmm... A visitor at such an early hour. What can I do for you traveler?", 0], #0
	["I would like to rent a room... I'll be leaving when the sun sets", 1], #1
	["Sunset? It's not even dawn yet, are you planning to sleep whole day?", 0], #2
	["Yes.", 1], #3
	["What's the matter? You're awfully quiet all of a sudden.", 1], #4
]

var moveArray = [
	[Vector2(-155,13), Vector2(-89, 5)],
	[Vector2(65,-45), Vector2(65,-45), Vector2(65,-45)],
	[Vector2(65,-45), Vector2(65,-45), Vector2(65,-45)]
]

var textBubble
var textLabel

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
			#var pos = innkeeper.position + textOffset
			addTextBubble()
			demoState = 2
		2: 
			if Input.is_action_just_pressed("ui_accept"):
				dialogProgress += 1
				updateText()
				if dialogProgress == 4:
					demoState = 3
		3:
			pass

func addTextBubble():
	textBubble = textBubblePath.instantiate()
	add_child(textBubble)
	textLabel = $textBubble/Label
	updateText()
	
func updateText():
	var actor = actorArray[textArray[dialogProgress][1]]
	textBubble.position = actor.position + textOffset
	textLabel.text = textArray[dialogProgress][0]
