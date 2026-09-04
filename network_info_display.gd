extends Control
class_name NetworkInfoDisplay

@export var connection_type_label: Label
@export var user_connection_type_lable: Label
@export var user_count_label: Label

func _ready() -> void:
	SessionManager.session_initialized.connect(session_initialize)

func session_initialize() -> void:
	update_network_info()
	SessionManager.session_state.user_joined.connect(user_joined)

func user_joined(pid: int) -> void:
	update_network_info()

func update_network_info():
	connection_type_label.text = ConnectionManager.ConnectionType.keys()[ConnectionManager.connection_type]
	user_connection_type_lable.text = "Host" if ConnectionManager.is_server() else "Client"
	
	if SessionManager.session_state:
		user_count_label.text = "Users: %d" % SessionManager.session_state.peer_to_user_state.size()
	else:
		user_count_label.text = "No session yet."
