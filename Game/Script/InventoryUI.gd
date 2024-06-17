extends Control

# Children variables
@onready var inspect_name = $Panel/Content/Items/Description/Name
@onready var inspect_desc = $Panel/Content/Items/Description/Description
@onready var inspect_texture = $Panel/Content/Items/Description/TextureRect
@onready var items = $Panel/Content/Items/ItemContainer/Items

@onready var item_container = preload("res://Prefabs/item_container.tscn")

@warning_ignore("unused_parameter")
func _process(delta):
	if Input.is_action_pressed("inv"):
		visible = true
	else:
		visible = false
	
	for i in items.get_child_count():
		var obj = items.get_child(i)
		
		if !obj.get_child(0).mouse_entered.is_connected(Callable(item_inspect).bind(obj)):
			obj.get_child(0).mouse_entered.connect(Callable(item_inspect).bind(obj))
	
	for i in Global.items:
		if !Global.item_containers.has(i.item_name):
			var itm = item_container.instantiate()
			
			itm.name = i.item_name
			itm.get_child(0).icon = i.image
			itm.get_child(1).text = i.description
			
			items.add_child(itm)
			
			Global.item_containers.append(i.item_name)

func item_inspect(obj):
	inspect_name.text = obj.name
	inspect_desc.text = obj.get_child(1).text
	inspect_texture.texture = obj.get_child(0).icon
