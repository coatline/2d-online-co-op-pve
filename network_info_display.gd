extends Control
class_name NetworkInfoDisplay

@export var connection_type_label: Label
@export var user_connection_type_lable: Label
@export var user_count_label: Label

func _ready() -> void:
	ConnectionManager.hosted_room.connect(update_network_info)
	SessionManager.user_joined.connect(func(peer_id: int): update_network_info())

func update_network_info():
	connection_type_label.text = ConnectionManager.ConnectionType.keys()[ConnectionManager.connection_type]
	user_connection_type_lable.text = "Host" if ConnectionManager.is_server() else "Client"
	
	if SessionManager.session_state:
		user_count_label.text = "Users: %d" % SessionManager.session_state.peer_to_user_state.size()
	else:
		user_count_label.text = "No session yet."
