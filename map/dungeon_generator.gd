class_name DungeonGenerator

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

var origin: Vector2i
var _parent: Map


func _init(map: Map) -> void:
	_parent = map


func generate() -> void:
	_parent.clear_map()

	var rooms: Array[Rect2i] = []
	for r: int in range(_parent.max_rooms):
		var room_width := randi_range(_parent.room_min_size, _parent.room_max_size)
		var room_height := randi_range(_parent.room_min_size, _parent.room_max_size)

		var x := randi_range(0, _parent.map_size.x - room_width - 1)
		var y := randi_range(0, _parent.map_size.y - room_height - 1)

		# define the formal bounds of the room as a Rect2i
		var room_bounds := Rect2i(x, y, room_width, room_height)

		# check if any rooms intersect with this one
		if rooms.any(func(other_room: Rect2i) -> bool: return room_bounds.intersects(other_room)):
			# the new room intersets, so try again
			continue

		var new_room := _rectanguar_room(room_bounds)

		if rooms.size() == 0:
			# the first room will be the player's start position
			origin = new_room.get_center()
		else:
			# use a tunnel to connect this room to the previous room
			_tunnel_between(rooms[-1].get_center(), new_room.get_center())

		rooms.append(new_room)


func clear() -> void:
	_parent.clear_map()

	for x: int in range(_parent.map_size.x):
		for y: int in range(_parent.map_size.y):
			var tile := Vector2i(x, y)
			_parent.tiles.set(tile, MAP_TILE_RESOURCES[MapTileType.WALL])
			_parent.set_cell(tile, _parent.source_id, MAP_TILE_RESOURCES[MapTileType.WALL].atlas_coord)


func _rectanguar_room(new_bounds: Rect2i) -> Rect2i:
	var bounds := new_bounds
	# inset the room position by 1 so it doesn't share a wall with any other rooms
	bounds.position += Vector2i.ONE

	var tile : Vector2
	for x in range(bounds.position.x + 1, bounds.end.x):
		for y in range(bounds.position.y + 1, bounds.end.y):
			tile = Vector2i(x, y)
			_set_floor_tile(tile)

	return bounds


func _tunnel_between(start: Vector2i, end: Vector2i) -> void:
	var corner : Vector2i

	if randf() < 0.5: # horizontal then vertical
		corner = Vector2i(end.x, start.y)
	else: # vertical then horizontal
		corner = Vector2i(start.x, end.y)

	var tiles := Geometry2D.bresenham_line(start, corner) + Geometry2D.bresenham_line(corner, end)
	for tile in tiles:
		_set_floor_tile(tile)


func _set_floor_tile(tile: Vector2i) -> void:
	var tile_resource: MapTileResource
	if randf() < 0.85:
		tile_resource = MAP_TILE_RESOURCES.get(MapTileType.FLOOR_1)
	else:
		tile_resource = MAP_TILE_RESOURCES.get(MapTileType.FLOOR_2)

	_parent.tiles.set(tile, tile_resource)
	_parent.set_cell(tile, _parent.source_id, tile_resource.atlas_coord)
