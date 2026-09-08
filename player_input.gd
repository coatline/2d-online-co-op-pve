extends Node2D
class_name PlayerInput

@export var game_player: GamePlayer
@export var player_body: PlayerBody

func _physics_process(_delta: float) -> void:
	if game_player.peer_id == ConnectionManager.get_peer_id():
		var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		CommandManager.move_player.rpc_id(1, direction)
		
		var mouse_pos = get_global_mouse_position()
		player_body.look_at(mouse_pos)

		CommandManager.rotate_player.rpc_id(1, player_body.rotation_degrees)
