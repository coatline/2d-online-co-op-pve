extends Node
# Autoload SessionSynchronizer

# Server sends updates to clients
# Clients send updates to server

func _ready() -> void:
	SessionManager.session_initialized.connect(_on_session_initialized)
	ConnectionManager.peer_disconnected.connect(_on_peer_disconnected)

func _on_session_initialized() -> void:
	if ConnectionManager.is_server():
		SessionManager.session_state.user_joined.connect(server_only_on_user_joined)

func server_only_on_user_joined(peer_id: int):
	if peer_id == ConnectionManager.get_peer_id():
		return
	
	NetworkLogger.I.print_networked("Initializing the user %d's networking info" % peer_id)
	update_session_state_rpc.rpc(SessionManager.session_state.serialize())

func _on_peer_disconnected(peer_id: int) -> void:
	NetworkLogger.I.print_networked("User %d left!" % peer_id)

	if ConnectionManager.is_server():
		SessionManager.session_state.remove_user(peer_id)
		GameSynchronizer.server_only_despawn_player(peer_id)
		update_session_state_rpc.rpc(SessionManager.session_state.serialize())


@rpc("any_peer", "call_remote", "reliable")
func server_join_client_rpc() -> void:
	if ConnectionManager.is_server():
		var peer_id: int = multiplayer.get_remote_sender_id()
		var user: UserState = SessionManager.try_get_user_state(peer_id)
		user.joined_game = true
		#GameSynchronizer.auth_spawn_new_player_at(Vector2.ZERO)
		GameSynchronizer.server_only_spawn_player(user)
		update_session_state_rpc.rpc(SessionManager.session_state.serialize())


@rpc("any_peer", "call_remote", "reliable")
func submit_user_info_rpc(username: String) -> void:
	if ConnectionManager.is_server():
		var peer_id: int = multiplayer.get_remote_sender_id()
		var new_user: UserState = UserState.new()
		new_user.peer_id = peer_id
		new_user.username = username
		SessionManager.session_state.add_user(new_user)
		NetworkLogger.I.print_networked("User %d submitted their info" % peer_id)

@rpc("authority", "call_remote", "reliable")
func update_session_state_rpc(session_state_dict: Dictionary) -> void:
	NetworkLogger.I.print_networked("Updating session state, %s" % session_state_dict)
	if SessionManager.session_state == null:
		SessionManager.session_state = SessionState.new()
	SessionManager.session_state.deserialize(session_state_dict)
	
	if SessionManager.initialized == false:
		SessionManager.initialize_session()

func server_start_game() -> void:
	if ConnectionManager.is_server():
		SessionManager.session_state.game_started = true
		NetworkLogger.I.print_networked("Starting game!")
		
		for user: UserState in SessionManager.session_state.peer_to_user_state.values():
			NetworkLogger.I.print_networked("Joining user %d" % user.peer_id)
			user.joined_game = true
			GameSynchronizer.server_only_spawn_player(user)
		
		#GameSynchronizer.auth_spawn_new_player_at(Vector2.ZERO)
		
		if ConnectionManager.is_online():
			update_session_state_rpc.rpc(SessionManager.session_state.serialize())


@rpc("authority", "call_remote", "unreliable")
func update_world_state_rpc(world_state_data: PackedByteArray) -> void:
	var binary_reader: BinaryReader = BinaryReader.new(world_state_data)
	GameSimulation.I.apply_world_state(binary_reader)

func _process(delta: float) -> void:
	if ConnectionManager.is_server() and ConnectionManager.is_online() and SessionManager.session_exists() and SessionManager.session_state.game_started:
		for user_state: UserState in SessionManager.session_state.peer_to_user_state.values():
			if user_state == SessionManager.get_my_user_state():
				continue
			if user_state.joined_game:
				var binary_writer: BinaryWriter = BinaryWriter.new()
				GameSimulation.I.world_state.serialize(binary_writer)
				update_world_state_rpc.rpc_id(user_state.peer_id, binary_writer.get_data())
