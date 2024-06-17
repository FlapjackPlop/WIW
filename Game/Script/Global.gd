extends Node

# Misc variables
var gravity = 2000

# Player variables
var player
var player_position
var player_damage = 20
var player_health = 50
var player_max_health = 50

var player_spawned = false

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

# Save/Load variables
var save_directory = "res://GlobalData.tres"

func _ready():
	paste_data(load_data())

func paste_data(data):
	if !data == null:
		player_position = data.player_position
		
		player_damage = data.player_damage
		player_health = data.player_health
		player_max_health = data.player_max_health
		
		level = data.level
		isotopes = data.isotopes
		max_heals = data.max_heals
		heals = data.heals
		
		items = data.items
		
		toxicity = data.toxicity
		endurance = data.endurance
		flame = data.flame

func save_data():
	var data = GlobalData.new()
	
	data.player_position = player.global_position
	
	data.player_damage = player_damage
	data.player_health = player_health
	data.player_max_health = player_max_health
	
	data.level = level
	data.isotopes = isotopes
	data.max_heals = max_heals
	data.heals = heals
	
	data.items = items
	
	data.toxicity = toxicity
	data.endurance = endurance
	data.flame = flame
	
	ResourceSaver.save(data, save_directory)

func load_data():
	if ResourceLoader.exists(save_directory):
		return load(save_directory)
	return null

@warning_ignore("unused_parameter")
func _process(delta):
	update_stats() # Handles stats
	
	if !player == null and !player_spawned and !player_position == null:
		player.global_position = player_position
		player_spawned = true
	
	if Input.is_action_just_pressed("jump"):
		save_data()
	
	if Input.is_action_just_pressed("restart"):
		# Restarts current scene
		var scene = get_tree().current_scene.scene_file_path
		get_tree().unload_current_scene()
		request_ready()
		get_tree().change_scene_to_file(scene)

func update_stats():
	if player != null:
		player.damage = round(player_damage * (1.10 ** toxicity)) # For every toxicity point, increase damage by 10%
		
		player.max_health = round(player_max_health * (1.15 ** endurance)) # For every endurance point, increase health by 15%
