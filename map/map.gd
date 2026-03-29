class_name Map
extends TileMapLayer

const MAP_TILE_RESOURCES := {
	"floor_1": preload("res://data/map_tiles/floor_1.tres"),
	"floor_2": preload("res://data/map_tiles/floor_2.tres"),
	"wall": preload("res://data/map_tiles/wall.tres")
}

var map_size : Vector2
var tiles : Dictionary[Vector2i, MapTileResource] = {}

@onready var source_id := tile_set.get_source_id(0)


func init(new_map_size: Vector2) -> void:
	map_size = new_map_size

	var tile : Vector2
	var tile_resource: MapTileResource

	for x: int in range(map_size.x):
		for y: int in range(map_size.y):
			tile = Vector2(x, y)

			if randf() < 0.85:
				tile_resource = MAP_TILE_RESOURCES.get("floor_1")
			else:
				tile_resource = MAP_TILE_RESOURCES.get("floor_2")

			tiles.set(tile, tile_resource)
			set_cell(tile, source_id, tile_resource.atlas_coord)

	for x: int in range(10, 15):
		tile = Vector2i(x, 8)
		tile_resource = MAP_TILE_RESOURCES.get("wall")
		tiles.set(tile, tile_resource)
		set_cell(tile, source_id, tile_resource.atlas_coord)


func global_to_tile(global: Vector2) -> Vector2i:
	return local_to_map(global) 


func is_in_bounds(tile: Vector2i) -> bool:
	return tiles.has(tile)


func is_walkable(tile: Vector2i) -> bool:
	return is_in_bounds(tile) and tiles[tile].walkable
