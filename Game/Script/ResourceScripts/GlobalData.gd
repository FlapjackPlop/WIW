extends Resource
class_name GlobalData

# Misc variables
@export var gravity = 2000

# Player variables
@export var player_position : Vector2

@export var player_damage = 20
@export var player_health = 50
@export var player_max_health = 50

@export var level = 0
@export var isotopes = 0
@export var max_heals = 4
@export var heals = 0

@export var items = []
@export var item_containers = []

@export var in_dialogue = false

# Stats
@export var toxicity = 0
@export var endurance = 0
@export var flame = 0
