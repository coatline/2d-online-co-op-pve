extends Node
class_name PlayerInput
#
#func _physics_process(_delta: float) -> void:
	#var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#if direction != Vector2.ZERO:
		#GameSimulation.I.peer_id_to_player[multiplayer.get_unique_id()].move(direction)
