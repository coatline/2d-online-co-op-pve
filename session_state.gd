class_name SessionState

var game_started: bool
var world_state: WorldState
var peer_to_user_state: Dictionary[int, UserState]

func get_user_state(peer_id: int) -> UserState:
	return peer_to_user_state[peer_id]
