extends StaticBody2D

@export var item_resource : Item

func _process(delta):
	if Global.items.has(item_resource):
		queue_free()
