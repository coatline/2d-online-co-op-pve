extends Node
# Autoload GameSynchronizer


# Go ahead and spawn it, even if you are the client.
# If you are the client, send the request to the server
func spawn_player() -> void:
	
	pass


@rpc("any_peer", "call_remote", "reliable")
func request_spawn(entity_type: int, position: Vector2) -> void:
	if ConnectionManager.is_server():
		# Add the entity to the server's world state.
		pass
