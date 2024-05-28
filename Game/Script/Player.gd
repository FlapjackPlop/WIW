extends CharacterBody2D

# Children variables
@onready var sword_collision_shape = $Sword/SwordCollision/CollisionShape
@onready var sword = $Sword
@onready var sword_sprite = $Sword/SwordSprite

var speed = 800
var damage = 20
var jump_speed = -1000
var gravity = 2000

var cayote_seconds = 0.15
var cayote = false
var stop_cayote = false
var jumping = false

var sword_rotation = 0
var attacking = false
var swinging = false

func _ready():
	$Cayote.wait_time = cayote_seconds # Sets cayote timer

func combat():
	# Attacks on mouse press
	if Input.is_action_pressed("attack") and !attacking and !swinging:
		attacking = true
		swinging = true
		
		$SwordSwing.start()
	
	# Activates sword collision if attacking
	if attacking:
		sword_sprite.visible = true
		sword_collision_shape.disabled = false
	else:
		sword_sprite.visible = false
		sword_collision_shape.disabled = true
		
		# Rotates sword based on direction
		if Input.is_action_pressed("left"):
			sword_rotation = 180
		elif Input.is_action_pressed("right"):
			sword_rotation = 0
		
		if Input.is_action_pressed("jump"):
			sword.rotation_degrees = -90
		elif Input.is_action_pressed("down") and !is_on_floor():
			sword.rotation_degrees = 90
		else:
			sword.rotation_degrees = sword_rotation

func _physics_process(delta):
	Global.player = self
	
	combat() # Handles combat
	
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
	if Input.is_action_pressed("jump") and (is_on_floor() or cayote):
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


func _on_sword_collision_body_entered(body):
	if body.is_in_group("enemy"):
		body.hit(damage)

func _on_cayote_timeout():
	# Stops the cayote
	cayote = false
	stop_cayote = true

func _on_sword_swing_timeout():
	# Stops attacking
	attacking = false
	$SwordCooldown.start()

func _on_sword_cooldown_timeout():
	# Stops swing
	swinging = false
