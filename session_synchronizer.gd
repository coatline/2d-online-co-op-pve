extends Node
# Autoload SessionSynchronizer

@onready var game_scene: PackedScene = preload("uid://cvwkjv2rk8kj2")
signal joined_game()

# Server sends updates to clients
# Clients send updates to server

func _ready() -> void:
	SessionManager.session_initialized.connect(begin_tracking)
	# SessionManager.session_state.user_joined.connect(_user_joined)

func begin_tracking() -> void:
	SessionManager.session_state.user_joined.connect(_user_joined)

func _user_joined(peer_id: int):
	if ConnectionManager.is_server() == false or peer_id == ConnectionManager.get_peer_id():
		return
	
	NetworkLogger.I.print_networked("Initializing the user %d's networking info" % peer_id)
	
	var user_state: UserState = SessionManager.session_state.get_user(peer_id)
	update_session_state.rpc(SessionManager.session_state.serialize())

	# var writer: BinaryWriter = BinaryWriter.new()
	# var user_state: UserState = SessionManager.try_get_user_state(peer_id)
	# writer.write_header_u8(NetworkTransport.PacketType.INITIALIZE_CLIENT)
	# user_state.serialize(writer)
	# NetworkTransport.send_packet_to(writer.get_data(), peer_id)
	
	# Send the session and user states to the game
	# initialize_new_user.rpc_id(peer_id, SessionManager.peer_to_user_state)

@rpc("any_peer", "call_remote", "reliable")
func submit_user_info(username: String) -> void:
	if ConnectionManager.is_server():
		var peer_id: int = multiplayer.get_remote_sender_id()
		var new_user: UserState = UserState.new()
		new_user.peer_id = peer_id
		new_user.username = username
		SessionManager.session_state.add_user(new_user)
		NetworkLogger.I.print_networked("User %d submitted their info" % peer_id)

@rpc("authority", "call_remote", "reliable")
func update_session_state(session_state_dict: Dictionary) -> void:
	NetworkLogger.I.print_networked("Updating session state, %s" % session_state_dict)
	if SessionManager.session_state == null:
		SessionManager.session_state = SessionState.new()
	SessionManager.session_state.deserialize(session_state_dict)
	
	if SessionManager.initialized == false:
		SessionManager.initialize_session()

#func join_game() -> void:
	#if ConnectionManager.is_server():
		#session_state.game_started = true
	#
	#var game = game_scene.instantiate()
	#get_tree().root.add_child(game)
	#joined_game.emit()
