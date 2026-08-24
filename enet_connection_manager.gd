extends PanelContainer
class_name ENetConnectionManager

signal server_created
signal server_joined

@export var host_ip: LineEdit
@export var host_port: LineEdit
@export var host_e_net_button: Button
@export var join_e_net_button: Button

var peer = ENetMultiplayerPeer.new()

func _ready() -> void:
	host_e_net_button.pressed.connect(_on_host_enet_pressed)
	join_e_net_button.pressed.connect(_on_join_pressed)

func _on_host_enet_pressed() -> void:
	peer.create_server(int(host_port.text))
	multiplayer.multiplayer_peer = peer
	
	server_created.emit()

func _on_join_pressed() -> void:
	peer.create_client(host_ip.text, int(host_port.text))
	multiplayer.multiplayer_peer = peer
	
	server_joined.emit()
