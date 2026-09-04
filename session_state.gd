extends RefCounted
class_name SessionState

var game_started: bool
var peer_to_user_state: Dictionary[int, UserState] = {}

func serialize() -> Dictionary:
	var users_dict: Dictionary[int, Dictionary] = {}
	
	for peer in peer_to_user_state.keys():
		users_dict[peer] = peer_to_user_state[peer].serialize()
	
	var dict: Dictionary = {
		"game_started" : game_started,
		"peer_to_user_state" : users_dict
	}
	
	return dict

func deserialize(dict: Dictionary) -> void:
	game_started = dict.game_started
	
	for peer in dict.peer_to_user_state.keys():
		var user_state: UserState = peer_to_user_state.get(peer)
		if user_state == null:
			user_state = UserState.new()
			peer_to_user_state[peer] = user_state
		
		user_state.deserialize(dict.peer_to_user_state[peer])
