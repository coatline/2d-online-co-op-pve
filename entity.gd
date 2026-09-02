extends Node
class_name Entity

enum Team { PLAYER, ENEMY }

@export var body: PhysicsBody2D
@export var team: Team
@export var id: int = -1

func load_state(entity_state: EntityState) -> void:
	body.global_position = entity_state.position
	body.velocity = entity_state.velocity
	body.rotation_degrees = entity_state.rotation_degrees

func update_state(entity_state: EntityState) -> void:
	entity_state.position = body.global_position
	entity_state.velocity = body.velocity
	entity_state.rotation_degrees = body.rotation_degrees

func _enter_tree() -> void:
	EntityManager.I.register_entity(id, self)

func _exit_tree() -> void:
	EntityManager.I.unregister_entity(id)
