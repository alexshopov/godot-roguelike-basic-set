class_name Game
extends Node

const GAME_SIZE := Vector2i(40, 22)

@onready var entity_manager : EntityManager = $EntityManager
@onready var event_handler : EventHandler = $EventHandler
@onready var map : Map = $Map


func _ready() -> void:
	print("Welcome to the dungeon.")

	map.init(GAME_SIZE)
	@warning_ignore("integer_division")
	var center := GAME_SIZE / 2
	entity_manager.init(center)


func _input(event: InputEvent) -> void:
	var action := event_handler.handle_input_event(event)

	if action:
		action.execute(self)
