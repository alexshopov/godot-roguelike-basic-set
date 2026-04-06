class_name Map
extends Node

@export var room_max_size : int = 10
@export var room_min_size : int = 6
@export var max_rooms : int = 30

var origin : Vector2i : 
	get():
		return dungeon_generator.origin
var map_size : Vector2i
var tiles : Dictionary[Vector2i, MapTileResource] = {}

@onready var dungeon_generator : DungeonGenerator = DungeonGenerator.new(self)
@onready var explored_tiles : TileMapLayer = $ExploredTiles
@onready var visible_tiles : TileMapLayer = $VisibleTiles
@onready var fov : FOV = FOV.new(self)


func init(new_map_size: Vector2i) -> void:
	map_size = new_map_size
	dungeon_generator.generate()


func clear_map() -> void:
	tiles.clear()
	explored_tiles.clear()
	visible_tiles.clear()


func update_player_fov(player: Entity) -> void:
	var tile := global_to_tile(player.global_position)
	fov.update(tile, player.vision_radius)


func tile_to_global(tile: Vector2i) -> Vector2:
	return explored_tiles.map_to_local(tile)


func global_to_tile(global: Vector2) -> Vector2i:
	return explored_tiles.local_to_map(global) 


func is_in_bounds(tile: Vector2i) -> bool:
	return tiles.has(tile)


func is_walkable(tile: Vector2i) -> bool:
	return is_in_bounds(tile) and tiles[tile].walkable


func save() -> Dictionary:
	var save_data: Dictionary = {}

	for tile in tiles:
		save_data.set(var_to_str(tile), tiles[tile].get_state())

	return save_data


func load(save_data: Dictionary) -> void:
	var source_id := explored_tiles.tile_set.get_source_id(0)

	clear_map()
	
	for data: String in save_data:
		var tile : Vector2i = str_to_var(data)
		var tile_map_resource := MapTileResource.new()
		tile_map_resource.set_state(save_data[data])
		tiles.set(tile, tile_map_resource)

		if tile_map_resource.explored:
			explored_tiles.set_cell(tile, source_id, tile_map_resource.atlas_coord)
