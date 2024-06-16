extends Node

# Misc variables
var gravity = 2000

# Player variables
var player
var player_damage = 20
var player_health = 50
var player_max_health = 50

var level = 0
var isotopes = 0
var max_heals = 4
var heals = 0

var items = []
var item_containers = []

var in_dialogue = false

# Stats
var toxicity = 0
var endurance = 0
var flame = 0

@warning_ignore("unused_parameter")
func _process(delta):
	update_stats() # Handles stats
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene() # Restarts current scene

func update_stats():
	if player != null:
		player.damage = round(player_damage * (1.10 ** toxicity)) # For every toxicity point, increase damage by 10%
		
		player.max_health = round(player_max_health * (1.15 ** endurance)) # For every endurance point, increase health by 15%
