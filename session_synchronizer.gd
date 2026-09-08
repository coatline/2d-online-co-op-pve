extends Node
# Autoload SessionSynchronizer

@onready var game_scene: PackedScene = preload("uid://cvwkjv2rk8kj2")
signal joined_game()

# Server sends updates to clients
# Clients send updates to server

func _ready() -> void:
	SessionManager.session_initialized.connect(begin_tracking)
	ConnectionManager.peer_disconnected.connect(_on_peer_disconnected)

func begin_tracking() -> void:
	SessionManager.session_state.user_joined.connect(_user_joined)
	SessionManager.session_state.get_my_user_state().spawned_in_game_changed.connect(_on_spawn_in_game_changed)

func _user_joined(peer_id: int):
	if ConnectionManager.is_server() == false or peer_id == ConnectionManager.get_peer_id():
		return
	
	NetworkLogger.I.print_networked("Initializing the user %d's networking info" % peer_id)
	
	update_session_state.rpc(SessionManager.session_state.serialize())

func _on_peer_disconnected(peer_id: int) -> void:
	NetworkLogger.I.print_networked("User %d left!" % peer_id)
	if ConnectionManager.is_server():
		SessionManager.session_state.remove_user(peer_id)
		update_session_state.rpc(SessionManager.session_state.serialize())


@rpc("any_peer", "call_remote", "reliable")
func server_join_client() -> void:
	if ConnectionManager.is_server():
		var peer_id: int = multiplayer.get_remote_sender_id()
		var user: UserState = SessionManager.try_get_user_state(peer_id)
		user.joined_game = true
		#GameSynchronizer.auth_spawn_new_player_at(Vector2.ZERO)
		update_session_state.rpc(SessionManager.session_state.serialize())


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

func server_start_game() -> void:
	if ConnectionManager.is_server():
		SessionManager.session_state.game_started = true
		NetworkLogger.I.print_networked("Starting game!")

		for user: UserState in SessionManager.session_state.peer_to_user_state.values():
			NetworkLogger.I.print_networked("Joining user %d" % user.peer_id)
			user.joined_game = true
			GameSynchronizer.server_only_spawn_player(user)
		
		#GameSynchronizer.auth_spawn_new_player_at(Vector2.ZERO)
		
		update_session_state.rpc(SessionManager.session_state.serialize())

func _on_spawn_in_game_changed(value: bool) -> void:
	if value:
		NetworkLogger.I.print_networked("I Spawned in!")
		var game = game_scene.instantiate()
		get_tree().root.add_child(game)
		joined_game.emit()

@rpc("authority", "call_remote", "unreliable")
func update_world_state(world_state_data: PackedByteArray) -> void:
	var binary_reader: BinaryReader = BinaryReader.new(world_state_data)
	GameSimulation.I.apply_world_state(binary_reader)

func _process(delta: float) -> void:
	if ConnectionManager.is_server() and ConnectionManager.is_online():
		if SessionManager.get_my_user_state().joined_game:
			for peer in multiplayer.get_peers():
				var user_state: UserState = SessionManager.try_get_user_state(peer)
				if user_state:
					if user_state.joined_game:
						var binary_writer: BinaryWriter = BinaryWriter.new()
						GameSimulation.I.world_state.serialize(binary_writer)
						update_world_state.rpc_id(peer, binary_writer.get_data())
