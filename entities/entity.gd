@tool
class_name Entity
extends Sprite2D

@export var entity_resource : EntityResource


func _ready() -> void:
	assert(entity_resource != null, "An entity_resource must be specified before adding the Entity to scene.")
	region_rect.position = entity_resource.atlas_coord * Constants.TILE_SIZE_VECTOR

	z_index = entity_resource.draw_layer
