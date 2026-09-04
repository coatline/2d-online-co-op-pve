extends Node
# Autoload SessionManager

signal session_initialized()

var session_state: SessionState
var initialized: bool = false


func _ready() -> void:
	ConnectionManager.joined_room.connect(_joined_room)
	ConnectionManager.hosted_room.connect(_on_hosted_room)
	ConnectionManager.disconnected_from_network.connect(end_session)


func initialize_session() -> void:
	initialized = true
	
	NetworkLogger.I.print_networked("Initialized session")
	session_initialized.emit()


func _joined_room() -> void:
	initialized = false
	
	SessionSynchronizer.submit_user_info.rpc_id(
		1,
		"Client %d" % multiplayer.get_unique_id()
	)


func _on_hosted_room() -> void:
	session_state = SessionState.new()
	
	create_user(
		multiplayer.get_unique_id(),
		"Host"
	)
	
	initialize_session()


func apply_session_state(data: Dictionary) -> void:
	if session_state == null:
		session_state = SessionState.new()
	
	session_state.deserialize(data)
	
	if not initialized:
		initialize_session()


# Server only.
func create_user(peer_id: int, username: String) -> void:
	if not is_server():
		return
	
	var user_state: UserState = UserState.new()
	user_state.peer_id = peer_id
	user_state.username = username
	
	session_state.add_user(user_state)


# Server only.
func remove_user(peer_id: int) -> void:
	if not is_server():
		return
	
	session_state.remove_user(peer_id)


func try_get_user_state(peer_id: int) -> UserState:
	if session_state == null:
		return null
	
	return session_state.get_user(peer_id)


func get_my_user_state() -> UserState:
	if session_state == null:
		return null
	
	return session_state.get_user(multiplayer.get_unique_id())


func is_server() -> bool:
	return ConnectionManager.is_server()


func end_session() -> void:
	session_state = null
	initialized = false
