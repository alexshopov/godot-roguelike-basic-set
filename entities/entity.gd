class_name Entity
extends Sprite2D

@export var entity_resource : EntityResource

var vision_radius := 8


func _ready() -> void:
	assert(entity_resource != null, "An entity_resource must be specified before adding the Entity to scene.")
	_load_resource()


func move(position_offset: Vector2i) -> void:
	global_position += Vector2(position_offset * Constants.TILE_SIZE)


func save() -> Dictionary:
	return {
		"position": var_to_str(global_position),
		"entity_resource": entity_resource.resource_path
	}


func load(save_data: Dictionary) -> void:
	var res: String = _load_property(save_data, "entity_resource")
	if res:
		_load_resource(res)

	var player_position: String = _load_property(save_data, "position")
	if player_position:
		global_position = str_to_var(player_position)


func _load_property(save_data: Dictionary, property: String) -> Variant:
	var prop: Variant = save_data.get(property)
	if prop == null:
		print("Load Error: error parsing entity.%s" % property)
		return null

	return prop


func _load_resource(resource_path: String = "") -> void:
	if resource_path:
		entity_resource = ResourceLoader.load(resource_path)

	texture = entity_resource.atlas_texture
	z_index = entity_resource.draw_layer
