class_name Game
extends Node

const GAME_SIZE := Vector2i(40, 22)

@onready var entity_manager : EntityManager = $EntityManager
@onready var event_handler : EventHandler = $EventHandler


func _ready() -> void:
	print("Welcome to the dungeon.")

	@warning_ignore("integer_division")
	var center := GAME_SIZE / 2
	entity_manager.player.global_position = center * Constants.TILE_SIZE
	entity_manager.npc.global_position = (center + Vector2i(5, 0)) * Constants.TILE_SIZE


func _input(event: InputEvent) -> void:
	var action := event_handler.handle_input_event(event)

	if action:
		action.execute(self)
