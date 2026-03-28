class_name SaveGameAction
extends Action


func execute(game: Game) -> void:
	SaveLoadManager.save(game)
