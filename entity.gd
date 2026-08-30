extends CharacterBody2D
class_name Entity

enum Team { PLAYER, ENEMY }

@export var root_node: Node
@export var team: Team
@export var id: int = -1

func load_state(entity_state: EntityState) -> void:
	global_position = entity_state.position
	velocity = entity_state.velocity
	rotation_degrees = entity_state.rotation_degrees

func update_state(entity_state: EntityState) -> void:
	entity_state.position = global_position
	entity_state.velocity = velocity
	entity_state.rotation_degrees = rotation_degrees

func _enter_tree() -> void:
	EntityManager.I.register_entity(id, self)

func _exit_tree() -> void:
	EntityManager.I.unregister_entity(id)
