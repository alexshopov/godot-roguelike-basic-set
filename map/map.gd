class_name Map
extends TileMapLayer

const MAP_TILE_RESOURCES := {
	"floor_1": preload("res://data/map_tiles/floor_1.tres"),
	"floor_2": preload("res://data/map_tiles/floor_2.tres"),
	"wall": preload("res://data/map_tiles/wall.tres")
}

var map_size : Vector2i
var tiles : Dictionary[Vector2i, MapTileResource] = {}

@onready var source_id := tile_set.get_source_id(0)


func init(new_map_size: Vector2i) -> void:
	map_size = new_map_size

	for x: int in range(map_size.x):
		for y: int in range(map_size.y):
			var tile := Vector2i(x, y)
			var tile_resource: MapTileResource

			if randf() < 0.85:
				tile_resource = MAP_TILE_RESOURCES.get("floor_1")
			else:
				tile_resource = MAP_TILE_RESOURCES.get("floor_2")

			tiles.set(tile, tile_resource)
			set_cell(tile, source_id, tile_resource.atlas_coord)

	for x: int in range(10, 15):
		var tile := Vector2i(x, 8)
		var tile_resource: MapTileResource = MAP_TILE_RESOURCES.get("wall")
		tiles.set(tile, tile_resource)
		set_cell(tile, source_id, tile_resource.atlas_coord)


func tile_to_global(tile: Vector2i) -> Vector2:
	return map_to_local(tile) - Constants.HALF_TILE_SIZE_VECTOR


func global_to_tile(global: Vector2) -> Vector2i:
	return local_to_map(global) 


func is_in_bounds(tile: Vector2i) -> bool:
	return tiles.has(tile)


func is_walkable(tile: Vector2i) -> bool:
	return is_in_bounds(tile) and tiles[tile].walkable
