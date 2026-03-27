class_name SaveGameAction
extends Action


func execute(game: Game) -> void:
	game.save_load_handler.save_game()
