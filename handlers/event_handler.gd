class_name EventHandler
extends Node

const DIRECTIONS := {
	"up": Vector2i.UP,
	"left": Vector2i.LEFT,
	"down": Vector2i.DOWN,
	"right": Vector2i.RIGHT
}


func handle_input_event(event: InputEvent) -> Action:
	if event is InputEventKey:
		return _handle_keyboard_event(event)

	return null


func _handle_keyboard_event(event: InputEventKey) -> Action:
	for direction: String in DIRECTIONS:
		if event.is_action_pressed("move_%s" % direction):
			return MovementAction.new(DIRECTIONS.get(direction))

	if event.is_action_pressed("ui_cancel"):
		return EscapeAction.new()

	return null
