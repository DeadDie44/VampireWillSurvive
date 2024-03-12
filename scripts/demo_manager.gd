extends Node

@onready var textBubblePath = preload("res://assets/objects/ui/text_bubble.tscn")

@onready var innkeeper = $characters/innkeeper
@onready var shrouded  = $characters/shrouded
@onready var stranger1 = $characters/stranger1
@onready var stranger2 = $characters/stranger2
@onready var stranger3 = $characters/stranger3

@onready var hintLabel = $foreground/hintLabel1
@onready var evilLabel = $foreground/evilLabel
@onready var goodLabel = $foreground/goodLabel

@onready var actorArray = [innkeeper, shrouded, stranger1, stranger2, stranger3]

var textOffset = Vector2(65,-45)
var destination = Vector2(-24, 5)
var demoState = 0
var dialogueProgress = 0


var textArray = [
	#longest message should be about this long:
	#"The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown"
	["Hmm... A visitor at such an early hour. What can I do for you traveler?", 0], #0
	["I would like to rent a room... I'll be leaving when the sun sets.", 1], #1
	["Sunset? It's not even dawn yet, are you planning to sleep whole day?", 0], #2
	["Yes.", 1], #3
	["What's the matter? You're awfully quiet all of a sudden.", 1], #4
	["Stay where you are.", 4], #5
	["Who are you and why have you come to this city?", 4], #6
]

var moveArray = [
	[Vector2(-155,13), Vector2(-89, 5)],
	[Vector2(47,-6), Vector2(47,-6)],
	[Vector2(87,104), Vector2(-1,50)]
]

var moveStage = [0, 0, 0]
var idleAnim = ["down_idle_stranger1", "down_idle_stranger2", "up_idle_stranger3"]

var textBubble
var textLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	innkeeper.play("down_idle_innkeeper")
	shrouded.play("up_move_shrouded")
	stranger1.play("down_idle_stranger1")
	stranger2.play("down_idle_stranger2")
	stranger3.play("up_idle_stranger3")
	
	hintLabel.visible = false
	evilLabel.visible = false
	goodLabel.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	match demoState:
		0:
			shrouded.position = shrouded.position.move_toward(destination, delta * 30)
			if (shrouded.position == destination):
				demoState = 1
				shrouded.play("up_idle_shrouded")
		1:
			#var pos = innkeeper.position + textOffset
			addTextBubble()
			demoState = 2
		2: 
			hintLabel.visible = true
			if Input.is_action_just_pressed("ui_accept"):
				dialogueProgress += 1
				updateText()
				if dialogueProgress == 4:
					hintLabel.visible = false
					demoState = 3
					stranger1.play("up_move_stranger1")
					stranger2.play("down_move_stranger2")
					stranger3.play("up_move_stranger3")
				if dialogueProgress == 6:
					hintLabel.visible = false
					demoState = 4
		3:
			for i in 3:
				processActorPosition(i, delta)
				
			if (stranger3.position == moveArray[2][moveStage[2]]):
				shrouded.play("down_idle_shrouded")
				dialogueProgress = 5
				updateText()
				demoState = 2
		4:
			#evilLabel.visible = true
			#evilLabel.position += Vector2(0,-delta * 10)
			#Here's where I want to implement actual dialogue with choices and consequences
			pass

func processActorPosition(index, delta):
	actorArray[index+2].position = actorArray[index+2].position.move_toward(moveArray[index][moveStage[index]], delta * 40)
	if (actorArray[index+2].position == moveArray[index][moveStage[index]]):
		if(moveStage[index] < moveArray[index].size() - 1):
			moveStage[index] += 1
		else:
			actorArray[index+2].play(idleAnim[index])

func addTextBubble():
	textBubble = textBubblePath.instantiate()
	add_child(textBubble)
	textLabel = $textBubble/Label
	updateText()
	
func updateText():
	var actor = actorArray[textArray[dialogueProgress][1]]
	textBubble.position = actor.position + textOffset
	textLabel.text = textArray[dialogueProgress][0]
