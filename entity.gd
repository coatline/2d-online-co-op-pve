extends Node2D
class_name Entity

enum Team { PLAYER, ENEMY }

@export var root_node: Node
@export var team: Team

var id: int

func _enter_tree() -> void:
	if multiplayer.is_server():
		id = EntityManager.register_entity(self)
