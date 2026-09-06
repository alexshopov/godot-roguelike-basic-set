class_name MapTileResource
extends Resource

enum Type {
	FLOOR_01,
	FLOOR_02,
	WALL
}

@export var type : Type

@export_category("Characteristics")
@export var walkable : bool
@export var transparent : bool

@export_category("Visuals")
@export var atlas_coord : Vector2i
