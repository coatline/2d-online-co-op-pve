extends Node2D
class_name Entity

@export var root_node: Node

var id: int

func _enter_tree() -> void:
	if multiplayer.is_server():
		id = EntityManager.register_entity(self)
