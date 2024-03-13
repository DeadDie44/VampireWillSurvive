extends Node2D

var timer = 0
@onready var button = $button
@onready var godotScreen = $godot
@onready var screenFade = $screenFade
@onready var title = $title

var startTimer = 0
var start = false

func _ready():
	button.pressed.connect(startGame)
#goodButton.pressed.connect(buttonPressed.bind(1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	
	if timer > 1.0:
		screenFade.fadeIn = false
	if timer > 1.9:
		godotScreen.visible = false
	if timer > 2.3:
		screenFade.fadeIn = true
	if timer > 3:
		button.visible = true
		
	if start == true:
		screenFade.fadeIn = false
		startTimer += delta
		button.visible = false
		
		if startTimer > 1:
			get_tree().change_scene_to_file("res://assets/scenes/demo_tavern.tscn")

func startGame():
	start = true
	button.visible = false
