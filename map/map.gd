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
var explored : Dictionary[Vector2i, bool] = {}

@onready var dungeon_generator : DungeonGenerator = DungeonGenerator.new(self)
@onready var explored_tilemap : TileMapLayer = $ExploredTiles
@onready var visible_tilemap : TileMapLayer = $VisibleTiles
@onready var fov : FOV = FOV.new(self)


func init(new_map_size: Vector2i) -> void:
	map_size = new_map_size
	dungeon_generator.generate()


func clear_map() -> void:
	tiles.clear()

	explored_tilemap.clear()
	explored.clear()
	visible_tilemap.clear()


func update_fov(player: Entity) -> void:
	var tile := global_to_tile(player.global_position)
	fov.update(tile, player.vision_radius)


func tile_to_global(tile: Vector2i) -> Vector2:
	return explored_tilemap.map_to_local(tile)


func global_to_tile(global: Vector2) -> Vector2i:
	return explored_tilemap.local_to_map(global) 


func is_in_bounds(tile: Vector2i) -> bool:
	return tiles.has(tile)


func is_walkable(tile: Vector2i) -> bool:
	return is_in_bounds(tile) and tiles[tile].walkable


func save() -> Dictionary:
	var save_data: Dictionary = {}

	for tile in tiles:
		var entry : Dictionary = {}
		entry.set("type", tiles[tile].type)

		if explored.has(tile):
			entry.set("explored", true)
		
		save_data.set(var_to_str(tile), entry)

	return save_data


func load(save_data: Dictionary) -> void:
	var source_id := explored_tilemap.tile_set.get_source_id(0)

	clear_map()
	
	for data: String in save_data:
		var entry : Dictionary = save_data.get(data)
		var tile : Vector2i = str_to_var(data)

		var type : MapTileResource.Type = entry.type
		var tile_map_resource : MapTileResource = dungeon_generator.MAP_TILE_RESOURCES[type]
		tiles.set(tile, tile_map_resource)

		if entry.has("explored"):
			explored.set(tile, true)
			explored_tilemap.set_cell(tile, source_id, tile_map_resource.atlas_coord)
