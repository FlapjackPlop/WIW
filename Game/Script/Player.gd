extends CharacterBody2D

var speed = 700
var jump_speed = -1000
var gravity = 2000

var cayote_seconds = 0.15
var cayote = false
var stop_cayote = false
var jumping = false

func _ready():
	$Cayote.wait_time = cayote_seconds # Sets cayote timer

func _physics_process(delta):
	# Add the gravity
	if !is_on_floor():
		velocity.y += gravity * delta
		
		# Handles cayote time
		if !jumping and !cayote and !stop_cayote:
			cayote = true
			$Cayote.start()
	else:
		# Resets variables
		jumping = false
		stop_cayote = false

	# Handle Jump
	if Input.is_action_just_pressed("jump") and (is_on_floor() or cayote):
		velocity.y = jump_speed
		jumping = true
	
	# Stops jumps mid air
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = lerpf(velocity.y, 0, 1)
	
	# Change x velocity according to input
	if Input.is_action_pressed("right"):
		velocity.x = speed * 100 * delta
	if Input.is_action_pressed("left"):
		velocity.x = -speed * 100 * delta
	
	# Sets x velocity to 0 when no input
	if Input.is_action_just_released("left") or Input.is_action_just_released("right"):
		velocity.x = 0
	
	move_and_slide()
	
	#print(velocity.y)

func _on_cayote_timeout():
	# Stops the cayote
	cayote = false
	stop_cayote = true
