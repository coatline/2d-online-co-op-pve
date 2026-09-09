extends Node2D
class_name Entity

enum Team { PLAYER, ENEMY }

@export var body: Node2D
@export var team: Team
@export var id: int = -1

var state: EntityState

func apply_state(entity_state: EntityState) -> void:
	state = entity_state
	id = entity_state.id
	body.global_position = entity_state.position
	body.rotation_degrees = entity_state.rotation_degrees

func get_current_state() -> EntityState:
	# var state: EntityState = GameSimulation.I.world_state.entity_id_to_state.get_or_add(id, EntityState.new())
	state.id = id
	state.position = body.global_position
	state.rotation_degrees = body.rotation_degrees
	return state

func _exit_tree() -> void:
	EntityManager.I.unregister_entity(id)
