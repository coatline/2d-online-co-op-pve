extends Control
class_name Lobby

@export var game: Game

@export var host_controls: Array[Control] = []
@export var player_card_scene: PackedScene
@export var player_card_holder: HBoxContainer
@export var copy_to_clipboard_button: Button
@export var start_button: Button
@export var quit_button: Button
@export var room_id_label: Label

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	start_button.pressed.connect(game.start_game)
	quit_button.pressed.connect(_quit_button_pressed)
	copy_to_clipboard_button.pressed.connect(_on_copy_to_clipboard_pressed)

func setup_screen() -> void:
	if !multiplayer.is_server():
		for c in host_controls:
			c.hide()
	else:
		spawn_card(1)
		multiplayer.peer_connected.connect(spawn_card)
		multiplayer.peer_disconnected.connect(remove_card)
	
	room_id_label.text = "room id: %s" % MultiplayerSessionManager.current_room

func spawn_card(pid: int):
	var player_card = player_card_scene.instantiate()
	player_card_holder.add_child(player_card)
	player_card.name = str(pid)

func remove_card(pid: int) -> void:
	var client_card = player_card_holder.get_node(str(pid))
	client_card.queue_free()

func _on_visibility_changed():
	if visible:
		setup_screen()

func _quit_button_pressed() -> void:
	multiplayer.multiplayer_peer.close()

func _on_copy_to_clipboard_pressed() -> void:
	DisplayServer.clipboard_set(MultiplayerSessionManager.current_room)
