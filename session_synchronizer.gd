extends Node
# Autoload SessionSynchronizer

signal player_joined_game(peer_id: int)

@rpc("authority", "call_local", "reliable")
func all_set_game_started() -> void:
	SessionManager.begin_game()

@rpc("any_peer", "call_local", "reliable")
func all_join_this_player_in_game() -> void:
	SessionManager.peer_to_user_state[multiplayer.get_remote_sender_id()].in_game = true
	player_joined_game.emit(multiplayer.get_remote_sender_id())
