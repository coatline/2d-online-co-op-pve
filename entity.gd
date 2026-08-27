extends Node
class_name Entity

var id: int

func _enter_tree() -> void:
	if multiplayer.is_server():
		id = EntityManager.register_entity(self)
