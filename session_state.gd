extends RefCounted
class_name SessionState

signal game_started_changed(value: bool)
signal user_joined(peer_id: int)
signal user_left(peer_id: int)

var peer_to_user_state: Dictionary[int, UserState] = {}

var game_started: bool:
	set(value):
		if game_started == value:
			return
		
		NetworkLogger.I.print_networked("GAME STARTYED!")
		game_started = value
		game_started_changed.emit(value)

func add_user(user_state: UserState) -> void:
	if peer_to_user_state.has(user_state.peer_id):
		return
	
	peer_to_user_state[user_state.peer_id] = user_state
	user_joined.emit(user_state.peer_id)


func remove_user(peer_id: int) -> void:
	if not peer_to_user_state.has(peer_id):
		return
	
	peer_to_user_state.erase(peer_id)
	user_left.emit(peer_id)


func get_user(peer_id: int) -> UserState:
	return peer_to_user_state.get(peer_id)


func get_my_user_state() -> UserState:
	return peer_to_user_state[ConnectionManager.get_peer_id()]


func serialize() -> Dictionary:
	var users_dict: Dictionary[int, Dictionary] = {}
	
	for peer_id: int in peer_to_user_state.keys():
		users_dict[peer_id] = peer_to_user_state[peer_id].serialize()
	
	return {
		"game_started": game_started,
		"peer_to_user_state": users_dict
	}


func deserialize(data: Dictionary) -> void:
	game_started = data.game_started
	
	var incoming_users: Dictionary = data.peer_to_user_state
	var removed_peers: Array[int] = []
	
	for peer_id: int in peer_to_user_state.keys():
		if not incoming_users.has(peer_id):
			removed_peers.append(peer_id)
	
	for peer_id: int in removed_peers:
		remove_user(peer_id)
	
	for peer_id: int in incoming_users.keys():
		var user_state: UserState = peer_to_user_state.get(peer_id)
		
		if user_state == null:
			user_state = UserState.new()
			user_state.peer_id = peer_id
			add_user(user_state)
		
		user_state.deserialize(incoming_users[peer_id])
