extends CharacterBody2D

# Misc variables
var gravity = Global.gravity

# Dummy variables
@onready var health = 100

func _ready():
	$HealthBar.max_value = health

func  UI():
	# Hides health bar if health is full
	if health == $HealthBar.max_value:
		$HealthBar.visible = false
	else:
		$HealthBar.visible = true
	
	# Sets the healthbar to the health
	$HealthBar.value = health

func death():
	queue_free() # Deletes itself

func _physics_process(delta):
	UI() # Handles UI
	
	if health <= 0:
		death() # Handles death
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = lerpf(velocity.x, 0, 0.1)
	
	move_and_slide()

func hit(dmg, knk):
	# Removes health based on damage
	health -= dmg
	
	# Calls knockback
	knockback(knk)

func knockback(strength):
	# Activates knockback
	if (Global.player.global_position.x - global_position.x) > 0:
		velocity.x = -strength * 100
	else:
		velocity.x = strength * 100
	velocity.y = -strength * 20
