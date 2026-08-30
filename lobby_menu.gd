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
	if multiplayer.is_server():
		if ConnectionManager.connection_type == ConnectionManager.ConnectionType.LAN:
			lan_container.show()
		
		spawn_card(multiplayer.get_unique_id())
		multiplayer.peer_connected.connect(spawn_card)
		multiplayer.peer_disconnected.connect(remove_card)
	elif SessionManager.get_my_user_state().in_game == false:
		start_button.hide()
	
	if ConnectionManager.connection_type == ConnectionManager.ConnectionType.NODE_TUNNEL:
		room_id_container.show()
		lan_container.hide()
	else:
		room_id_container.hide()
	
	room_id_label.text = "room id: %s" % SessionManager.current_room

func spawn_card(pid: int):
	var player_card = player_card_scene.instantiate()
	player_card_holder.add_child(player_card)
	player_card.name = str(pid)

func remove_card(pid: int) -> void:
	var client_card = player_card_holder.get_node(str(pid))
	client_card.queue_free()

func _on_start_game_pressed() -> void:
	if multiplayer.is_server():
		SessionSynchronizer.set_game_started_all()
	else:
		SessionSynchronizer.set_user_in_game_all()
		close()

func _quit_button_pressed() -> void:
	multiplayer.multiplayer_peer.close()

func _on_copy_to_clipboard_pressed() -> void:
	DisplayServer.clipboard_set(SessionManager.current_room)
