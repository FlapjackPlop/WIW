extends CharacterBody2D

# Children variables
@onready var sword_collision_shape = $Sword/SwordCollision/CollisionShape
@onready var sword = $Sword
@onready var sword_sprite = $Sword/SwordSprite
@onready var animation_player = $Visuals/AnimationPlayer
@onready var temp_character = $Visuals/TempCharacter
@onready var health_num = $UI/Control/HealthNum
@onready var health_bar = $UI/Control/HealthBar
@onready var isotopes_num = $UI/Control/IsotopesNum

# Misc variables
var gravity = Global.gravity

# Player variables
var speed = 800
var damage = Global.player_damage
var health = Global.player_health
var max_health = Global.player_max_health
var knockback = 15
var jump_speed = -1000

# Cayote time variables
var cayote_seconds = 0.15
var cayote = false
var stop_cayote = false
var jumping = false

# Sword variables
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

func animations():
	if is_on_floor():
		if velocity.x > 0 or velocity.x < 0:
			if !animation_player.current_animation == "Run":
				animation_player.play("Run")
		else:
			if !animation_player.current_animation == "Idle":
				animation_player.play("Idle")
	else:
		if !animation_player.current_animation == "Jump":
			animation_player.play("Jump")
	
	if velocity.x > 0:
		temp_character.scale.x = 1
	elif velocity.x < 0:
		temp_character.scale.x = -1

func hit(dmg, knk):
	# Removes health based on damage
	health -= dmg

func death():
	queue_free() # Deletes itself

func UI():
	health_num.text = str(health) + "/" + str(max_health) # Displays amount of health relative to max health
	
	# Displayes health on health bar
	health_bar.max_value = max_health
	health_bar.value = health
	
	isotopes_num.text = str(Global.isotopes) # Displayes isotopes

func _physics_process(delta):
	Global.player = self
	Global.player_health = health
	
	combat() # Handles combat
	animations() # Handles animations
	UI() # Handles UI
	
	if health <= 0:
		death() # Handles death
	
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
	if !attacking:
		if Input.is_action_pressed("right"):
			velocity.x = speed * 100 * delta
		if Input.is_action_pressed("left"):
			velocity.x = -speed * 100 * delta
	else:
		velocity.x = lerpf(velocity.x, 0, 0.2)
	
	# Sets x velocity to 0 when no input
	if Input.is_action_just_released("left") or Input.is_action_just_released("right"):
		velocity.x = 0
	
	move_and_slide()
	
	#print(velocity.y)


func _on_sword_collision_body_entered(body):
	if body.is_in_group("enemy"):
		body.hit(damage, knockback)

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
