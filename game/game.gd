class_name Game
extends Node

const GAME_SIZE := Vector2i(40, 22)
const TILE_SIZE := Vector2i(16, 16)

@onready var event_handler : EventHandler = $EventHandler
@onready var player : Sprite2D = $Player


func _ready() -> void:
	print("Welcome to the dungeon.")

	@warning_ignore("integer_division")
	var center := GAME_SIZE / 2
	player.global_position = center * TILE_SIZE


func _input(event: InputEvent) -> void:
	var action := event_handler.handle_input_event(event)

	if action:
		action.execute(self)
