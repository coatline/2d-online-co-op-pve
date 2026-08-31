extends Node
class_name PlayerInput

func _physics_process(_delta: float) -> void:
	if SessionManager.is_server():
		return
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction != Vector2.ZERO:
		NetworkTransport.I.command_move.rpc_id(1, direction)
