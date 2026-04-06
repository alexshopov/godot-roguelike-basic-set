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
	player = _spawn_entity(ENTITY_RESOURCES.get("player"))
	player.global_position = origin * Constants.TILE_SIZE

	var camera := Camera2D.new()
	camera.name = "camera"
	player.add_child(camera)

	npc = _spawn_entity(ENTITY_RESOURCES.get("npc"))
	npc.global_position = (origin + Vector2i(5, 0)) * Constants.TILE_SIZE


func _spawn_entity(entity_resource: EntityResource = null) -> Entity:
	var new_entity := ENTITY_SCENE.instantiate()

	if entity_resource:
		new_entity.entity_resource = entity_resource

	add_child(new_entity)

	return new_entity


func save() -> Dictionary:
	var save_data: Dictionary = {}

	save_data.set("player", player.save())
	save_data.set("npc", npc.save())

	return save_data


func load(save_data: Dictionary) -> void:
	player.load(save_data.get("player"))
	npc.load(save_data.get("npc"))
