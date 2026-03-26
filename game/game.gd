class_name Game
extends Node

const GAME_SIZE := Vector2i(40, 22)
const TILE_SIZE := Vector2i(16, 16)

@onready var event_handler : EventHandler = $EventHandler
@onready var player : Sprite2D = $Player


func _ready() -> void:
	print("Welcome to the dungeon.")

	var origin := GAME_SIZE / 2
	player.global_position = tile_to_global(origin)


func _input(event: InputEvent) -> void:
	var action := event_handler.handle_input_event(event)

	if action is MovementAction:
		player.global_position += Vector2(action.offset * TILE_SIZE)
	elif action is EscapeAction:
		get_tree().quit()


func tile_to_global(tile: Vector2i) -> Vector2:
	return tile * TILE_SIZE
