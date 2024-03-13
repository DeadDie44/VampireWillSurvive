extends Node

@onready var textBubblePath = preload("res://assets/objects/ui/text_bubble.tscn")
@onready var buttonPath = preload("res://assets/objects/ui/button.tscn")
@onready var explosionPath = preload("res://assets/objects/blood_explosion.tscn")

@onready var innkeeper = $characters/innkeeper
@onready var shrouded  = $characters/shrouded
@onready var stranger1 = $characters/stranger1
@onready var stranger2 = $characters/stranger2
@onready var stranger3 = $characters/stranger3

@onready var hintLabel = $foreground/hintLabel1
@onready var evilLabel = $foreground/evilLabel
@onready var goodLabel = $foreground/goodLabel

@onready var screenFade = $screenFade

@onready var actorArray = [innkeeper, shrouded, stranger1, stranger2, stranger3]

var deathStarted = false

var alignmentPoints = 0
var buttonProgressOffest = 0
var demoState = 0
var dialogueProgress = 0

var finalCoutdown = 0

var destination = Vector2(-24, 5)
var leaveDestination = Vector2(-24, 205)
var strangerDestination = Vector2(10, 50)
var textOffset = Vector2(65,-45)

var moveStage = [0, 0, 0]
var moveArray = [
	[Vector2(-155,13), Vector2(-89, 5)],
	[Vector2(47,-6), Vector2(47,-6)],
	[Vector2(87,104), Vector2(-1,50)]
]

var textArray = [
	#longest message should be about this long:
	#"The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown"
	["Hmm... A visitor at such an early hour. What can I do for you stranger?", 0], #0
	["I would like to rent a room... I'll be leaving when the sun sets.", 1], #1
	["Sunset? It's not even dawn yet, are you planning to sleep whole day?", 0], #2
	["Yes.", 1], #3
	["What's the matter? You're awfully quiet all of a sudden.", 1], #4
	["Stay where you are.", 4], #5
	["Who are you?", 4], #6
	["Why have you come to this city?", 4], #7
	["I do not like your answers. You're hiding someting.", 4], #8
]

var endText = [
	"Enough, you won't be staying here. Leave this place and this city immediately. Whoever you are.",
	"That's enough! Surrender now, we'll find out who you really are one way or another.",
	"Very well. I'm leaving, you won't see me again.",
	"We watching your every step. No tricks.",
	"Enough is indeed enough.",
	"You shouldn't have tested my patience.",
]

var idleAnim = ["down_idle_stranger1", "down_idle_stranger2", "up_idle_stranger3"]

var buttonArray = [
	["I am a mere traveler.","Nobody for you to worry about."],
	["Just passing by, I need some rest.","None of your buisness."],
	["I won't cause any trouble...","I don't like your questions."]
	]

var goodButton
var evilButton

var textBubble
var textLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Tavern scene loaded")
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
	if Input.is_action_just_pressed("ui_left"):
		explodeActor(innkeeper)
		
	match demoState:
		0:
			shrouded.position = shrouded.position.move_toward(destination, delta * 30)
			if (shrouded.position == destination):
				demoState = 1
				shrouded.play("up_idle_shrouded")
			
		1:
			addTextBubble()
			demoState = 2
		2: 
			hintLabel.visible = true
			if dialogueProgress == 9:
				if alignmentPoints < 0:
					setTextBubble(stranger3, endText[1])
				else:
					setTextBubble(stranger3, endText[0])
				demoState = 5
				
			elif Input.is_action_just_pressed("ui_accept"):
				dialogueProgress += 1
				#updateText()
				if dialogueProgress == 4:
					hintLabel.visible = false
					demoState = 3
					stranger1.play("up_move_stranger1")
					stranger2.play("down_move_stranger2")
					stranger3.play("up_move_stranger3")
				elif dialogueProgress == 6:
					hintLabel.visible = false
					demoState = 4
					buttonProgressOffest = dialogueProgress
					addButtons()
					updateButtons()
				updateText()
					
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
			#or not
			pass
		5:
			if finalCoutdown == 0:
				if Input.is_action_just_pressed("ui_accept"):
					hintLabel.visible = false
					if (alignmentPoints < 0):
						explodeActor(innkeeper)
						explodeActor(stranger1)
						explodeActor(stranger2)
						explodeActor(stranger3)
						
						setTextBubble(shrouded, endText[4])
						#Init evil game 
						#get_tree().change_scene_to_file("res://assets/scenes/bad_ending.tscn")
					else:
						setTextBubble(shrouded, endText[2])
						shrouded.play("down_move_shrouded")
						#Init evil game 
						#get_tree().change_scene_to_file("res://assets/scenes/good_ending.tscn")
					finalCoutdown += delta
			else: 
				finalCoutdown += delta
				if alignmentPoints >= 0:
					shrouded.position = shrouded.position.move_toward(leaveDestination, delta * 30)
					stranger3.position = stranger3.position.move_toward(strangerDestination, delta * 30)
					stranger3.play("down_idle_stranger3")
					
			if alignmentPoints < 0 && finalCoutdown > 0.5 && !deathStarted:
					deathStarted = true
					var speed = 2
					innkeeper.play("death")
					innkeeper.speed_scale = speed
					stranger1.play("death")
					stranger1.speed_scale = speed
					stranger2.play("death")
					stranger2.speed_scale = speed
					stranger3.play("death")
					stranger3.speed_scale = speed
			
			if finalCoutdown > 4:
				screenFade.fadeIn = false
				#textBubble.visible = false
				
			if finalCoutdown > 5:
				if (alignmentPoints < 0):
					#Init evil game 
					get_tree().change_scene_to_file("res://assets/scenes/bad_ending.tscn")
				else:
					#Init evil game 
					get_tree().change_scene_to_file("res://assets/scenes/good_ending.tscn")

func explodeActor(actor):
	var explosion = explosionPath.instantiate()
	add_child(explosion)
	explosion.position = actor.position

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
	var text = textArray[dialogueProgress][0]
	setTextBubble(actor, text)
	#textBubble.position = actor.position + textOffset
	#textLabel.text = textArray[dialogueProgress][0]

func setTextBubble(actor, text):
	textBubble.position = actor.position + textOffset
	textLabel.text = text
	
func addButtons():
	var pos = Vector2(25,50)
	
	goodButton = buttonPath.instantiate()
	add_child(goodButton)
	goodButton.position = pos
	goodButton.pressed.connect(buttonPressed.bind(1))
	
	evilButton = buttonPath.instantiate()
	add_child(evilButton)
	evilButton.position = pos + Vector2(0,24)
	evilButton.pressed.connect(buttonPressed.bind(-1))
	
func updateButtons():
	var index = dialogueProgress - buttonProgressOffest
	goodButton.text = buttonArray[index][0]
	evilButton.text = buttonArray[index][1]
	
func buttonPressed(i):
	dialogueProgress += 1
	alignmentPoints += i
	if (dialogueProgress == 9):
		goodButton.queue_free()
		evilButton.queue_free()
		demoState = 2
	else:
		updateText()
		updateButtons()
