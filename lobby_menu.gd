extends UIMenu
class_name LobbyMenu

@export var room_id_container: VBoxContainer
@export var lan_container: VBoxContainer

@export var player_card_scene: PackedScene
@export var player_card_holder: HBoxContainer
@export var copy_to_clipboard_button: Button
@export var start_button: Button
@export var quit_button: Button
@export var room_id_label: Label

func _ready() -> void:
	start_button.pressed.connect(_on_start_game_pressed)
	quit_button.pressed.connect(_quit_button_pressed)
	copy_to_clipboard_button.pressed.connect(_on_copy_to_clipboard_pressed)

func on_open() -> void:

	for ui in player_card_holder.get_children():
		ui.queue_free()

	for user: UserState in SessionManager.session_state.peer_to_user_state.values():
		spawn_card(user)
	
	# Show different ui based on connection type
	if ConnectionManager.is_server():
		if ConnectionManager.connection_type == ConnectionManager.ConnectionType.LAN:
			lan_container.show()
		
		start_button.show()
	else:
		start_button.hide()
	#elif SessionManager.get_my_user_state().in_game == false:
	
	if ConnectionManager.connection_type == ConnectionManager.ConnectionType.NODE_TUNNEL:
		room_id_container.show()
		lan_container.hide()
		room_id_label.text = "room id: %s" % SessionManager.current_room
	else:
		room_id_container.hide()
	
	SessionManager.session_terminated.connect(_on_session_terminated)
	SessionManager.session_state.user_joined.connect(user_joined)
	SessionManager.session_state.user_left.connect(user_left)

func on_close() -> void:
	SessionManager.session_state.user_left.disconnect(user_left)
	SessionManager.session_state.user_joined.disconnect(user_joined)
	SessionManager.session_terminated.disconnect(_on_session_terminated)

# if the session is terminated, and I'm still active, go back.
func _on_session_terminated():
	back()

# if back() gets called and i haven't terminated the session, terminate it
func on_back() -> void:
	# If we aren't going back because we just terminated, terminate.
	if SessionManager.initialized:
		SessionManager.terminate_session()

func user_joined(pid: int) -> void:
	spawn_card(SessionManager.try_get_user_state(pid))

func user_left(pid: int) -> void:
	remove_card(pid)

func spawn_card(user_state: UserState):
	var lobby_player_ui: LobbyPlayerUI = player_card_scene.instantiate()
	lobby_player_ui.setup(user_state)
	lobby_player_ui.name = str(user_state.peer_id)
	player_card_holder.add_child(lobby_player_ui)

func remove_card(pid: int) -> void:
	var client_card = player_card_holder.get_node(str(pid))
	client_card.queue_free()

func _on_start_game_pressed() -> void:
	if ConnectionManager.is_server():
		SessionSynchronizer.join_game()
		pass
		#SessionSynchronizer.start_game()
		# SessionManager.join_game()
		# SessionSynchronizer.all_set_game_started()
	else:
		pass
		# SessionSynchronizer.all_join_this_player_in_game()
	
	close()

func _quit_button_pressed() -> void:
	SessionManager.terminate_session()
	# multiplayer.multiplayer_peer.close()

func _on_copy_to_clipboard_pressed() -> void:
	DisplayServer.clipboard_set(SessionManager.current_room)
