class_name MovementAction
extends Action

var offset : Vector2i


func _init(new_offset: Vector2i) -> void:
	offset = new_offset


func execute(game: Game) -> void:
	var map := game.map
	var player := game.entity_manager.player

	var new_tile:= map.global_to_tile(player.global_position) + offset
	if map.is_in_bounds(new_tile) and map.is_walkable(new_tile):
		game.entity_manager.player.move(offset)
