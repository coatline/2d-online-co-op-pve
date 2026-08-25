extends UIMenu
class_name OnlineConnectionMenu

@export var connecting_indicator: VBoxContainer
@export var connection_ui: VBoxContainer

@export var lobby: LobbyMenu
@export var room_holder: VBoxContainer

@export var host_room_button: Button

@export var join_private_room_button: Button
@export var join_room_id_line_edit: LineEdit

@export var back_button: Button

func _ready() -> void:
	join_private_room_button.pressed.connect(_on_join_private_room_pressed)
	host_room_button.pressed.connect(_on_host_room_pressed)
	back_button.pressed.connect(back)

func on_open() -> void:
	connection_ui.hide()
	connecting_indicator.show()
	await MultiplayerSessionManager.connect_to_relay()
	connecting_indicator.hide()
	connection_ui.show()

func on_close() -> void:
	MultiplayerSessionManager._disconnect_current_session()

func _on_host_room_pressed() -> void:
	var room_id = await MultiplayerSessionManager.host_new_room(true, "New Room")
	DisplayServer.clipboard_set(room_id)
	lobby.open()

func _on_join_private_room_pressed() -> void:
	await MultiplayerSessionManager.join_room(join_room_id_line_edit.text)
	lobby.open()
