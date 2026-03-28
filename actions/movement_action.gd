class_name MovementAction
extends Action

var offset : Vector2i


func _init(new_offset: Vector2i) -> void:
	offset = new_offset


func execute(game: Game) -> void:
	game.entity_manager.player.global_position += Vector2(offset * Constants.TILE_SIZE)
