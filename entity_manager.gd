extends Node
class_name EntityManager

static var I: EntityManager

var next_entity_id: int = 1
var entities: Dictionary[int, Entity] = {}

func _init() -> void:
	I = self

func get_next_entity_id() -> int:
	next_entity_id += 1
	return next_entity_id - 1

func register_entity(id: int, entity: Entity):
	entities[id] = entity

func get_entity(id: int) -> Entity:
	return entities.get(id, null)

func unregister_entity(id: int) -> void:
	entities.erase(id)
