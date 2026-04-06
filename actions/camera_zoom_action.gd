class_name CameraZoomAction
extends Action


func execute(game: Game) -> void:
	var player: Entity = game.entity_manager.player
	var camera: Camera2D = player.get_node_or_null("camera")
	if not camera:
		return

	if camera.zoom == Vector2.ONE:
		camera.top_level = true
		camera.global_position = (game.GAME_SIZE / 2) * Constants.TILE_SIZE
		camera.zoom = Vector2(0.5, 0.5)
	else:
		camera.top_level = false
		camera.global_position = player.global_position
		camera.zoom = Vector2.ONE
