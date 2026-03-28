class_name EntityManager
extends Node

const ENTITY_SCENE : PackedScene = preload("res://entities/entity.tscn")
const ENTITY_RESOURCES : Dictionary[String, EntityResource] = {
	"player": preload("res://data/entities/player.tres"),
	"npc": preload("res://data/entities/npc.tres")
}

@export var map : Map

var player : Entity
var npc : Entity


func init() -> void:
	@warning_ignore("integer_division")
	var center: Vector2i = map.map_size / 2

	player = ENTITY_SCENE.instantiate()
	player.entity_resource = ENTITY_RESOURCES.get("player")
	add_child(player)
	player.global_position = center * Constants.TILE_SIZE

	npc = ENTITY_SCENE.instantiate()
	npc.entity_resource = ENTITY_RESOURCES.get("npc")
	add_child(npc)
	npc.global_position = (center + Vector2i(5, 0)) * Constants.TILE_SIZE
