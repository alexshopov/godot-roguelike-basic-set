class_name FOV

signal fov_updated

var _explored_layer : TileMapLayer
var _visible_layer : TileMapLayer
var _map : Map 
var _source_id : int
var _visible_tiles : Array[Vector2i]


func _init(new_map: Map) -> void:
	_map = new_map
	_explored_layer = _map.explored_tiles
	_visible_layer = _map.visible_tiles
	_source_id = _explored_layer.tile_set.get_source_id(0)

	clear()


func update(origin: Vector2i, radius: float) -> void:
	_clear_visible()
	_set_visible(origin)

	for octant in range(8):
		_scan(origin, radius, 1, 1.0, 0.0, octant)

	fov_updated.emit()


func update_player_fov(player: Entity) -> void:
	var tile := _map.global_to_tile(player.global_position)
	update(tile, 8)
	# update(tile, player.stats.vision_radius)


func clear() -> void:
	_visible_tiles.clear()
	_visible_layer.clear()


func _clear_visible() -> void:
	for tile in _visible_tiles:
		_map.tiles[tile].visible = false

	clear()


func _set_visible(tile: Vector2i) -> void:
	if not _map.is_in_bounds(tile):
		return

	_visible_tiles.append(tile)
	_set_explored(tile)
	_visible_layer.set_cell(tile, _source_id, _map.tiles[tile].atlas_coord)


func _set_explored(tile: Vector2i) -> void:
	_map.tiles[tile].visible = true

	if _map.tiles[tile].explored:
		return

	_map.tiles[tile].explored = true
	_map.explored_tiles.set_cell(tile, _source_id, _map.tiles[tile].atlas_coord)


func _scan(origin: Vector2i, radius: float, row: int, start_slope: float, end_slope: float, octant: int) -> void:
	if start_slope < end_slope:
		return

	var next_start_slope := start_slope
	var radius_sq := radius * radius

	for distance in range(row, radius + 1):
		var blocked := false

		for dy in range(-distance, 1):
			var dx := -distance
			var target_pos := origin + _transform_octant(dx, dy, octant)

			var left_slope := (dy - 0.5) / (dx + 0.5)
			var right_slope := (dy + 0.5) / (dx - 0.5)

			if start_slope < right_slope:
				continue
			if end_slope > left_slope:
				break

			# if we are here the tile is within the viewing cone
			if (dx * dx + dy * dy) <= radius_sq:
				_set_visible(target_pos)

			var tile: MapTileResource = _map.tiles.get(target_pos)
			var is_opaque: bool = tile == null or not tile.transparent

			if blocked:
				if is_opaque:
					next_start_slope = right_slope
				else:
					blocked = false
					start_slope = next_start_slope
			else:
				if is_opaque and distance < radius:
					blocked = true
					_scan(origin, radius, distance + 1, start_slope, left_slope, octant)
					next_start_slope = right_slope

		if blocked:
			break


func _transform_octant(x: int, y: int, octant: int) -> Vector2i:
	match octant:
		0: return Vector2i(-x,  y)
		1: return Vector2i( y, -x)
		2: return Vector2i( y,  x)
		3: return Vector2i(-x, -y)
		4: return Vector2i( x, -y)
		5: return Vector2i(-y,  x)
		6: return Vector2i(-y, -x)
		7: return Vector2i( x,  y)
	
	return Vector2i.ZERO
