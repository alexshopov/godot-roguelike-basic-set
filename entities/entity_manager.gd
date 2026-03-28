class_name EntityManager
extends Node

const ENTITY_SCENE : PackedScene = preload("res://entities/entity.tscn")
const ENTITY_RESOURCES : Dictionary[String, EntityResource] = {
    "player": preload("res://data/entities/player.tres"),
    "npc": preload("res://data/entities/npc.tres")
}

var entity_grid : Dictionary[Vector2i, Entity] = {}
var player : Entity
var npc : Entity

func _ready() -> void:
    player = ENTITY_SCENE.instantiate()
    player.entity_resource = ENTITY_RESOURCES.get("player")
    add_child(player)

    npc = ENTITY_SCENE.instantiate()
    npc.entity_resource = ENTITY_RESOURCES.get("npc")
    add_child(npc)
