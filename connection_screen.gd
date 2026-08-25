extends Control
class_name ConnectionScreen

@export var lobby: Lobby
@export var e_net_connection_manager: ENetConnectionManager

func _ready() -> void:
	e_net_connection_manager.server_created.connect(_host_handler)
	e_net_connection_manager.server_joined.connect(_join_handler)

func _host_handler() -> void:
	lobby.show()
	hide()

func _join_handler() -> void:
	lobby.show()
	hide()
