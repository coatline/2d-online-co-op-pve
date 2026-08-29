extends Node
# Autoload SessionManager

signal user_joined(peer_id: int)
signal user_left(peer_id: int)

var session_state: SessionState
var current_room: String

func _ready() -> void:
	ConnectionManager.hosted_room.connect(_on_hosted_room)
	ConnectionManager.peer_connected.connect(_on_peer_connected)
	ConnectionManager.peer_disconnected.connect(_on_peer_disconnected)
	ConnectionManager.disconnected_from_network.connect(_on_network_disconnected)

func start_session() -> void:
	if not ConnectionManager.is_connected_to_network():
		push_error("Cannot start session without a network connection.")
		return
	
	if session_state:
		end_session()
	
	session_state = SessionState.new()
	
	if multiplayer.is_server():
		create_user(multiplayer.get_unique_id())

func _on_hosted_room(peer_id: int) -> void:
	current_room = ""
	start_session()

func _on_peer_connected(peer_id: int) -> void:
	if multiplayer.is_server():
		create_user(peer_id)

func create_user(peer_id: int) -> void:
	var order: int = session_state.peer_to_user_state.size()
	var user_state: UserState = UserState.new(peer_id, "Player %d" % (order + 1))
	session_state.peer_to_user_state[peer_id] = user_state
	
	user_joined.emit(peer_id)
	
	print("Registered user: ", peer_id)

func _on_peer_disconnected(peer_id: int) -> void:
	user_left.emit(peer_id)

func end_session() -> void:
	session_state = null
	current_room = ""

func _on_network_disconnected() -> void:
	end_session()

func get_my_user_state() -> UserState:
	return session_state.peer_to_user_state[multiplayer.get_unique_id()]
