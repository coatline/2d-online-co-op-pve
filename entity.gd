extends Node2D
class_name Entity

enum Team { PLAYER, ENEMY }

@export var root_node: Node
@export var team: Team
@export var id: int = -1

func take_data(entity_state: EntityState):
	root_node.global_position = entity_state.position
	root_node.global_rotation = entity_state.rotation_degrees
	#root_node.v`elocity = entity_state.velocity
	pass

#var entity_id: int
#var entity_type: int
#var position: Vector2
#var velocity: Vector2
#var rotation: float
func _enter_tree() -> void:
	EntityManager.I.register_entity(id, self)

func _exit_tree() -> void:
	EntityManager.I.unregister_entity(id)
