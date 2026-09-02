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

# @export_category("State")
# @export var explored : bool
# @export var visible : bool

@export_category("Visuals")
@export var atlas_coord : Vector2i


# func get_state() -> Dictionary[String, Variant]:
# 	return {
# 		"walkable": walkable,
# 		"transparent": transparent,
# 		"explored": explored,
# 		"atlas_coord": var_to_str(atlas_coord)
# 	}


# func set_state(state: Dictionary) -> void:
# 	walkable = state.get("walkable", false)
# 	transparent = state.get("transparent", false)
# 	explored = state.get("explored", false)
# 	atlas_coord = str_to_var(state.get("atlas_coord"))
