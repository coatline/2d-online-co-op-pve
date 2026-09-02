extends Control
class_name NetworkInfoDisplay

@export var connection_type_label: Label
@export var user_connection_type_lable: Label
@export var user_count_label: Label

func _ready() -> void:
	ConnectionManager.hosted_room.connect(update_network_info)
	ConnectionManager.peer_connected.connect(update_network_info)

func update_network_info(pid: int):
	connection_type_label.text = ConnectionManager.ConnectionType.keys()[ConnectionManager.connection_type]
	user_connection_type_lable.text = "Host" if SessionManager.is_server() else "Client"
	user_count_label.text = "Users: %d" % SessionManager.peer_to_user_state.size()
