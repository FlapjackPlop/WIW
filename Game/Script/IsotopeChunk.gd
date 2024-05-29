extends CharacterBody2D

var speed = 150

@onready var isotope_count = 5

func _physics_process(delta):
	var direction = global_position.direction_to(Global.player.global_position) # Gets direction to player
	
	speed = lerpf(speed, speed + 200, 0.01) # Increases speed
	
	velocity = direction * speed # Moves toward direction
	
	move_and_slide()

func _on_area_2d_body_entered(body):
	# Destroyes itself and adds to the isotope count if in contact with player
	if body.is_in_group("player"):
		queue_free()
		Global.isotopes += isotope_count
