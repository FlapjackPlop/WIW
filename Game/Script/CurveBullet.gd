extends CharacterBody2D

# Children variables
@onready var life_time = $LifeTime

# Bullet variables
var curve_speed = 800
var speed = 64000
var curve_height = 30
var direction = -1

@onready var damage = 7
@onready var knockback = 10

var x
var y

func _ready():
	x = global_position.x
	y = global_position.y
	
	# Starts life
	life_time.start()

func _physics_process(delta):
	if direction == 1:
		velocity.y -= curve_speed * delta
	elif direction == -1:
		velocity.y += curve_speed * delta
	
	if global_position.y > (y + curve_height):
		direction = 1
	if global_position.y < (y - curve_height):
		direction = -1
	
	velocity.y = clampf(velocity.y, -400, 400)
	
	velocity.x = speed * delta
	
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.hit(damage, knockback)
		queue_free()

func _on_life_time_timeout():
	# Delete bullet when life ends
	queue_free()
