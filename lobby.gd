extends Control
class_name Lobby

signal started_game
signal quit_game

@export var host_controls: Array[Control] = []
@export var player_card_scene: PackedScene
@export var player_card_holder: HBoxContainer
@export var start_button: Button
@export var quit_button: Button
@export var room_id_label: Label
@export var copy_to_clipboard_button: Button

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	start_button.pressed.connect(func(): started_game.emit())
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
		room_id_label.text = "room id: %s" % MultiplayerManager.current_room

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
	quit_game.emit()

func _on_copy_to_clipboard_pressed() -> void:
	DisplayServer.clipboard_set(MultiplayerManager.current_room)
