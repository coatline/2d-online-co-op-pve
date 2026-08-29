class_name EntityState

enum EntityType { PLAYER, ENEMY, PROJECTILE }

var entity_id: int
var entity_type: int
var position: Vector2
var velocity: Vector2
var rotation_degrees: float

func serialize() -> Array:
	return [entity_id, position, velocity, rotation_degrees]

static func deserialize(data: Array) -> EntityState:
	var state: EntityState = EntityState.new()
	state.entity_id = data[0]
	state.position = data[1]
	state.velocity = data[2]
	state.rotation_degrees = data[3]
	return state
