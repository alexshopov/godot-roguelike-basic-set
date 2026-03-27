class_name LoadGameAction
extends Action


func execute(game: Game) -> void:
    game.save_load_handler.load_game()
