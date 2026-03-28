class_name LoadGameAction
extends Action


func execute(game: Game) -> void:
	SaveLoadManager.load(game)
