extends CharacterBody2D

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

const ACCELERATION = 96
const MAX_SPEED  = 72
const FRICTION = 244

enum {
	MOVE,
	ATTACK
}

var state = MOVE
var speed = 0

func _ready():
	animationTree.active = true

func _process(delta):
	match state:
		MOVE:
			move(delta)
		ATTACK:
			attack(delta)

	#Esc to quit game	
	if Input.is_action_just_pressed("ui_text_clear_carets_and_selection"):
		get_tree().quit()

func _physics_process(delta):
	move_and_slide()

func move(delta):
	var x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	var input_vector = Vector2 (x,y).normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/idle/blend_position", input_vector)
		animationTree.set("parameters/move/blend_position", input_vector)
		animationTree.set("parameters/attack/blend_position", input_vector)
		animationState.travel("move")
		speed += ACCELERATION * delta
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		velocity = input_vector * speed
	else:
		animationState.travel("idle")
		speed = 0
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func attack(delta):
	velocity *= 0.1
	animationState.travel("attack")

func attack_finished():
	print("attack finished")
	state = MOVE
