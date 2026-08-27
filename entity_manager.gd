extends Node
# Autoload EntityManager

var entities: Dictionary[int, Entity] = {}
var next_id: int = 1

func register_entity(entity: Entity) -> int:
	var id = next_id
	next_id += 1
	entities[id] = entity
	return id
