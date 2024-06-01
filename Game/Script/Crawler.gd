extends CharacterBody2D

# Children Variables
@onready var animation_player = $Visuals/AnimationPlayer

# Misc variables
var gravity = Global.gravity

var crawling = false
var paused = false
var direction = 1

var stop_moving = false

@onready var bullet = preload("res://Prefabs/curve_bullet.tscn")
@onready var isotope = preload("res://Prefabs/isotope_chunk.tscn")

# Crawler variables
@onready var health = 50
@onready var damage = 100
@onready var speed = 32000

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
	
	stop_moving = true

func death():
	# Deletes itself
	queue_free()
	
	# Spawn isotopes
	var isotope_num = randi_range(2, 8)
	var a = 0
	
	while a < isotope_num:
		var isotope_instance = isotope.instantiate()
		
		isotope_instance.global_position = global_position + Vector2(randf_range(-60, 60), randf_range(-60, 60))
		
		get_parent().add_child(isotope_instance)
		a += 1

func movement(delta):
	if !paused and !crawling:
		if direction == 1:
			velocity.x = speed * delta
			
			direction = -1
		else:
			velocity.x = -speed * delta
			
			direction = 1
		
		$CrawlTime.wait_time = randf_range(0.1, 2)
		$CrawlTime.start()
		crawling = true

func animation():
	if stop_moving:
		animation_player.play("Hurt")
	else:
		if velocity.x != 0:
			animation_player.play("Walk")

func _physics_process(delta):
	animation() # Handles animation
	
	if health <= 0:
		death() # Handles death
	
	if !stop_moving:
		movement(delta) # Handles movement
	else:
		velocity.x = lerpf(velocity.x, 0, 0.1)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()

func _on_crawl_time_timeout():
	paused = true
	velocity.x = 0
	
	var bullet_instance = bullet.instantiate()
	
	bullet_instance.global_position = $ShootPoint.global_position
	bullet_instance.curve_height = randi_range(5, 30)
	
	if randi_range(0, 100) > 50:
		bullet_instance.direction = 1
	else:
		bullet_instance.direction = -1
	
	if Global.player.global_position.x < global_position.x:
		bullet_instance.speed = -bullet_instance.speed
	
	get_parent().add_child(bullet_instance)
	
	animation_player.play("Shoot")
	
	$PauseTime.wait_time = randf_range(0.1, 2)
	$PauseTime.start()

func _on_pause_time_timeout():
	paused = false
	crawling = false
