extends Node
# Autoload LocalSessionManager
#
#enum SessionMode { SINGLEPLAYER, HOST, CLIENT }
#var session_mode: SessionMode = SessionMode.SINGLEPLAYER
#
#var my_user_state: UserState
#var username: String
#var in_game: bool
#
#func _ready() -> void:
	#ConnectionManager.joined_room.connect(_on_joined_room)
	#ConnectionManager.hosted_room.connect(_on_hosted_room)
	#ConnectionManager.peer_connected.connect(_on_peer_connected)
	#ConnectionManager.peer_disconnected.connect(_on_peer_disconnected)
	#ConnectionManager.disconnected_from_network.connect(_on_network_disconnected)
	#my_user_state = UserState.new("User")
#
#func _on_hosted_room(peer_id: int) -> void:
	#current_room = ""
	#
	#create_user(ConnectionManager.get_peer_id())
	#
	## TEMP:
	#my_user_state.username = "Host"
	#session_mode = SessionMode.HOST
#
#func _on_joined_room(peer_id: int) -> void:
	## TEMP:
	#my_user_state.username = "Client"
	#session_mode = SessionMode.CLIENT
#
#func _on_peer_connected(peer_id: int) -> void:
	#if ConnectionManager.is_server():
		#create_user(peer_id)
#
#func create_user(peer_id: int) -> void:
	#var order: int = peer_to_user_state.size()
	#var user_state: UserState = UserState.new(peer_id, "Player %d" % (order + 1))
	#join_user(user_state)
#
#func join_user(user_data: UserState) -> void:
	#NetworkLogger.I.print_networked("Registered user: %d" % user_data.peer_id)
	#peer_to_user_state[user_data.peer_id] = user_data
	#user_joined.emit(user_data.peer_id)
#
#func _on_peer_disconnected(peer_id: int) -> void:
	#user_left.emit(peer_id)
#
#func begin_game() -> void:
	#game_started = true
#
	#var game = game_scene.instantiate()
	#get_tree().root.add_child(game)
	#game_began.emit()
	#
	##SessionSynchronizer.all_join_this_player_in_game.rpc()
#
#func _on_network_disconnected() -> void:
	#peer_to_user_state.clear()
	#game_started = false
	#pass
#
#func try_get_user_state(peer_id: int) -> UserState:
	#return peer_to_user_state.get(peer_id)
#
#func get_my_user_state() -> UserState:
	#return peer_to_user_state[ConnectionManager.get_peer_id()]
#
#
#func is_server() -> bool:
	#return session_mode == SessionMode.SINGLEPLAYER or session_mode == SessionMode.HOST
