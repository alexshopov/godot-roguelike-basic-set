class_name SaveLoadHandler
extends Node

const SAVE_FILENAME := "user://savegame.json"
const PLAYER_POSITION := "player_position"

@export var player : Sprite2D


func save_game() -> void:
	var save_data := {
		PLAYER_POSITION: vec2_to_str(player.global_position)
	}

	var json_str := JSON.stringify(save_data)
	var file := FileAccess.open(SAVE_FILENAME, FileAccess.WRITE)
	file.store_string(json_str)


func load_game() -> void:
	var file := FileAccess.open(SAVE_FILENAME, FileAccess.READ)
	var json_str := file.get_line()

	var save_data: Dictionary = JSON.parse_string(json_str)

	player.global_position = str_to_vec2(save_data.get(PLAYER_POSITION))


func vec2_to_str(v: Vector2) -> String:
	return "%d,%d" % [v.x, v.y]


func str_to_vec2(s: String) -> Vector2:
	var parts := s.split(",")
	return Vector2(int(parts[0]), int(parts[1]))
