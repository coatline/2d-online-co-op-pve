class_name PlayerState
extends EntityState

var peer_id: int
var health: int

func serialize() -> Array:
	return [entity_id, peer_id, position, velocity, rotation, health]

static func deserialize(data: Array) -> PlayerState:
	var state: PlayerState = PlayerState.new()
	state.entity_id = data[0]
	state.peer_id = data[1]
	state.position = data[2]
	state.velocity = data[3]
	state.rotation = data[4]
	state.health = data[5]
	return state
