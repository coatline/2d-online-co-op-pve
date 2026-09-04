extends Node
# Autoload SessionManager

signal user_joined(peer_id: int)
signal user_left(peer_id: int)

signal connection_initialized()


var session_state: SessionState

func _ready() -> void:
	ConnectionManager.joined_room.connect(_joined_room)
	ConnectionManager.hosted_room.connect(_on_hosted_room)
	# ConnectionManager.peer_connected.connect(_on_peer_connected)
	ConnectionManager.disconnected_from_network.connect(end_session)

func start_session():
	NetworkLogger.I.print_networked("Starting session")
	connection_initialized.emit()

func _joined_room() -> void:
	SessionSynchronizer.submit_user_info.rpc_id(1, "Client %d" % multiplayer.get_unique_id())

func _on_hosted_room() -> void:
	session_state = SessionState.new()
	create_user(multiplayer.get_unique_id(), "Host")
	
	start_session()

# func _on_peer_connected(peer_id: int) -> void:
# 	if ConnectionManager.is_server():
# 		create_user(peer_id)

# Server only
func create_user(peer_id: int, username: String) -> void:
	var user_state: UserState = UserState.new(peer_id, username)
	join_user(user_state)

func join_user(user_data: UserState) -> void:
	NetworkLogger.I.print_networked("Registered user: %d" % user_data.peer_id)
	session_state.peer_to_user_state[user_data.peer_id] = user_data
	user_joined.emit(user_data.peer_id)

func end_session() -> void:
	session_state = null

func try_get_user_state(peer_id: int) -> UserState:
	return session_state.peer_to_user_state.get(peer_id)

func get_my_user_state() -> UserState:
	return session_state.peer_to_user_state[multiplayer.get_unique_id()]
