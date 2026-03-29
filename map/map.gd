class_name Map
extends TileMapLayer

enum MapTileType {
	FLOOR_1,
	FLOOR_2,
	WALL
}

const MAP_TILE_RESOURCES := {
	MapTileType.FLOOR_1: preload("res://data/map_tiles/floor_1.tres"),
	MapTileType.FLOOR_2: preload("res://data/map_tiles/floor_2.tres"),
	MapTileType.WALL : preload("res://data/map_tiles/wall.tres")
}

var map_size : Vector2i
var tiles : Dictionary[Vector2i, MapTileResource] = {}

@onready var source_id := tile_set.get_source_id(0)


func init(new_map_size: Vector2i) -> void:
	map_size = new_map_size

	var tile : Vector2
	var tile_resource: MapTileResource

	for x: int in range(map_size.x):
		for y: int in range(map_size.y):
			tile = Vector2(x, y)

			if randf() < 0.85:
				tile_resource = MAP_TILE_RESOURCES.get(MapTileType.FLOOR_1)
			else:
				tile_resource = MAP_TILE_RESOURCES.get(MapTileType.FLOOR_2)

			tiles.set(tile, tile_resource)
			set_cell(tile, source_id, tile_resource.atlas_coord)

	for x: int in range(10, 15):
		tile = Vector2i(x, 8)
		tile_resource = MAP_TILE_RESOURCES.get(MapTileType.WALL)
		tiles.set(tile, tile_resource)
		set_cell(tile, source_id, tile_resource.atlas_coord)


func tile_to_global(tile: Vector2i) -> Vector2:
	return map_to_local(tile)


func global_to_tile(global: Vector2) -> Vector2i:
	return local_to_map(global) 


func is_in_bounds(tile: Vector2i) -> bool:
	return tiles.has(tile)


func is_walkable(tile: Vector2i) -> bool:
	return is_in_bounds(tile) and tiles[tile].walkable


func save() -> Dictionary:
	var save_data: Dictionary = {}

	for tile in tiles:
		save_data.set(var_to_str(tile), tiles[tile].resource_path)

	return save_data


func load(save_data: Dictionary) -> void:
	tiles.clear()
	clear()

	for data: String in save_data:
		var tile : Vector2i = str_to_var(data)
		var tile_map_resource := ResourceLoader.load(save_data[data])
		tiles.set(tile, tile_map_resource)
		set_cell(tile, source_id, tile_map_resource.atlas_coord)
