extends Node
# Autoload CommandManager

func move_player(direction: Vector2) -> void:
	var peer_id: int = ConnectionManager.get_peer_id()

	_apply_move(peer_id, direction)

	if ConnectionManager.is_server() == false:
		move_player_rpc.rpc_id(1, direction)


@rpc("any_peer", "unreliable")
func move_player_rpc(direction: Vector2) -> void:
	var peer_id: int = multiplayer.get_remote_sender_id()
	_apply_move(peer_id, direction)


func _apply_move(peer_id: int, direction: Vector2) -> void:
	var player_id: int = GameSynchronizer.get_player_id_from_peer(peer_id)
	if player_id == -1:
		return
	
	var player: GamePlayer = EntityManager.I.get_entity(player_id)
	player.player_body.movement = direction


func rotate_player(rotation_degrees: float) -> void:
	var peer_id: int = ConnectionManager.get_peer_id()

	_apply_rotation(peer_id, rotation_degrees)

	if ConnectionManager.is_server() == false:
		rotate_player_rpc.rpc_id(1, rotation_degrees)


@rpc("any_peer", "unreliable")
func rotate_player_rpc(rotation_degrees: float) -> void:
	var peer_id: int = multiplayer.get_remote_sender_id()
	_apply_rotation(peer_id, rotation_degrees)


func _apply_rotation(peer_id: int, rotation_degrees: float) -> void:
	var player_id: int = GameSynchronizer.get_player_id_from_peer(peer_id)
	if player_id == -1:
		return
	var player: GamePlayer = EntityManager.I.get_entity(player_id)
	player.player_body.rotation_degrees = rotation_degrees
