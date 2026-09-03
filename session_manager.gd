extends Node
# Autoload SessionManager

signal user_joined(peer_id: int)
signal user_left(peer_id: int)
signal game_began()

enum SessionMode { SINGLEPLAYER, HOST, CLIENT }

@onready var game_scene: PackedScene = preload("uid://cvwkjv2rk8kj2")

var session_mode: SessionMode = SessionMode.SINGLEPLAYER

var peer_to_user_state: Dictionary[int, UserState]
var game_started: bool

var current_room: String

func _ready() -> void:
	ConnectionManager.joined_room.connect(_on_joined_room)
	ConnectionManager.hosted_room.connect(_on_hosted_room)
	ConnectionManager.peer_connected.connect(_on_peer_connected)
	ConnectionManager.peer_disconnected.connect(_on_peer_disconnected)
	ConnectionManager.disconnected_from_network.connect(_on_network_disconnected)

func _on_hosted_room(peer_id: int) -> void:
	current_room = ""
	
	if not ConnectionManager.is_connected_to_network():
		push_error("Cannot start session without a network connection.")
		return
	
	end_session()
	
	create_user(multiplayer.get_unique_id())
	session_mode = SessionMode.HOST

func _on_joined_room(peer_id: int) -> void:
	#current_room = ConnectionManager.
	session_mode = SessionMode.CLIENT

func _on_peer_connected(peer_id: int) -> void:
	if SessionManager.is_server():
		create_user(peer_id)

func create_user(peer_id: int) -> void:
	var order: int = peer_to_user_state.size()
	var user_state: UserState = UserState.new(peer_id, "Player %d" % (order + 1))
	peer_to_user_state[peer_id] = user_state
	NetworkLogger.I.print_networked("Registered user: %d" % peer_id)
	user_joined.emit(peer_id)

func _on_peer_disconnected(peer_id: int) -> void:
	user_left.emit(peer_id)

func begin_game() -> void:
	game_started = true

	var game = game_scene.instantiate()
	get_tree().root.add_child(game)
	game_began.emit()
	
	#SessionSynchronizer.all_join_this_player_in_game.rpc()

func end_session() -> void:
	current_room = ""

func _on_network_disconnected() -> void:
	end_session()

func get_user_state(peer_id: int) -> UserState:
	return peer_to_user_state[peer_id]

func get_my_user_state() -> UserState:
	return peer_to_user_state[multiplayer.get_unique_id()]

func is_server() -> bool:
	return session_mode == SessionMode.SINGLEPLAYER or session_mode == SessionMode.HOST
