class_name EntityManager
extends Node

const ENTITY_SCENE : PackedScene = preload("res://entities/entity.tscn")
const ENTITY_RESOURCES : Dictionary[String, EntityResource] = {
	"player": preload("res://data/entities/player.tres"),
	"npc": preload("res://data/entities/npc.tres")
}

var player : Entity
var npc : Entity


func init(origin: Vector2i) -> void:
	player = ENTITY_SCENE.instantiate()
	player.entity_resource = ENTITY_RESOURCES.get("player")
	add_child(player)
	player.global_position = origin * Constants.TILE_SIZE

	npc = ENTITY_SCENE.instantiate()
	npc.entity_resource = ENTITY_RESOURCES.get("npc")
	add_child(npc)
	npc.global_position = (origin + Vector2i(5, 0)) * Constants.TILE_SIZE
