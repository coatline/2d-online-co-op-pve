extends Node2D
class_name Entity

enum Team { PLAYER, ENEMY }

@export var root_node: Node
@export var team: Team
@export var id: int = -1

func _enter_tree() -> void:
	EntityManager.I.register_entity(id, self)

func _exit_tree() -> void:
	EntityManager.I.unregister_entity(id)
