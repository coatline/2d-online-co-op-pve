extends UIMenu
class_name LANConnectionMenu

@export var lobby: LobbyMenu

@export var join_ip_line_edit: LineEdit
@export var join_port_line_edit: LineEdit
@export var join_lan_button: Button

@export var host_lan_button: Button
@export var host_port_line_edit: LineEdit

func _ready() -> void:
	join_lan_button.pressed.connect(try_join_lan)
	host_lan_button.pressed.connect(host_lan)
	SessionManager.session_initialized.connect(lobby.open)

func host_lan() -> void:
	ConnectionManager.host_lan(int(host_port_line_edit.text))
	#lobby.open()

func try_join_lan():
	# TODO: check to make sure that this is an actual valid host
	ConnectionManager.join_lan(join_ip_line_edit.text, int(join_port_line_edit.text))
	#await get_tree().create_timer(0.5).timeout
	#await ConnectionManager.connected_to_network
	#lobby.open()
