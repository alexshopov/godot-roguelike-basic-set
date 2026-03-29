extends Node

const SAVE_FILENAME := "user://savegame.json"
const PLAYER_DATA := "player"


func save(game: Game) -> void:
	var save_data := {
		PLAYER_DATA: game.entity_manager.player.save()
	}

	var json_str := JSON.stringify(save_data)
	var file := _open_file(FileAccess.WRITE)
	if not file:
		return

	file.store_string(json_str)
	print("Game saved successfully.")


func load(game: Game) -> void:
	var file := _open_file(FileAccess.READ)
	if not file:
		return

	var json_str := file.get_line()
	var save_data := JSON.parse_string(json_str) as Dictionary
	if not save_data:
		print("Error parsing saved data.")
		return


	game.entity_manager.player.load(save_data.get(PLAYER_DATA))
	print("Game loaded.")


func _open_file(flags: FileAccess.ModeFlags) -> FileAccess:
	var file := FileAccess.open(SAVE_FILENAME, flags)
	if not file:
		var err := FileAccess.get_open_error()
		print("Failed to open %s. Error: %s" % [SAVE_FILENAME, error_string(err)])
		return null

	return file
