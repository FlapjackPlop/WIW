extends CharacterBody2D

var health = 100

var gravity = 2000

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
	# Deletes itself if health is 0
	if health <= 0:
		queue_free()

func _physics_process(delta):
	UI() # Handles UI
	death() # Handles death
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = lerpf(velocity.x, 0, 0.1)
	
	move_and_slide()

func hit(damage):
	# Removes health based on damage
	health -= damage
	
	# Calls knockback
	knockback(damage)

func knockback(strength):
	if (Global.player.global_position.x - global_position.x) > 0:
		velocity.x = -strength * 100
	else:
		velocity.x = strength * 100
	velocity.y = -strength * 10
