extends VBoxContainer
class_name OnlineRoomManager

signal server_created
signal server_joined

@export var room_id_line_edit: LineEdit
@export var host_e_net_button: Button
@export var join_e_net_button: Button

func _ready() -> void:
	host_e_net_button.pressed.connect(_on_host_enet_pressed)
	join_e_net_button.pressed.connect(_on_join_pressed)

func _on_host_enet_pressed() -> void:
	var room_id = await MultiplayerSessionManager.host_new_room()
	DisplayServer.clipboard_set(room_id)
	server_created.emit()

func _on_join_pressed() -> void:
	await MultiplayerSessionManager.join_room(room_id_line_edit.text)
	server_joined.emit()
