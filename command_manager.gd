extends Node
# Autoload CommandManager

@rpc("any_peer", "call_local", "unreliable")
func move_player(direction: Vector2) -> void:
	var player_id: int = GameSynchronizer.peer_id_to_player_id[multiplayer.get_remote_sender_id()]
	var player: GamePlayer = EntityManager.I.get_entity(player_id)
	player.player_body.movement = direction

@rpc("any_peer", "call_local", "unreliable")
func rotate_player(_rotation_degrees: float) -> void:
	var player_id: int = GameSynchronizer.peer_id_to_player_id[multiplayer.get_remote_sender_id()]
	var player: GamePlayer = EntityManager.I.get_entity(player_id)
	player.player_body.rotation_degrees = _rotation_degrees
