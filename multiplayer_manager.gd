extends Node
# Autoload

signal connected_to_a_room

var peer: NodeTunnelPeer
var current_room: String


func _ready() -> void:
	connect_to_relay()

func connect_to_relay():
	peer = NodeTunnelPeer.new()
	peer.connect_to_relay("us-east.nodetunnel.io:8080", "I made a game! and this is a unique id")
	multiplayer.multiplayer_peer = peer
	
	print("Authenticating...")
	await peer.authenticated
	print("Authenticated!")

func host_new_room() -> String:
	peer.host_room(true, "My Room")
	print("Hosting room")
	await peer.room_connected
	print("Now hosting room: ", peer.room_id)
	current_room = peer.room_id
	connected_to_a_room.emit()
	return current_room

func join_room(room_id: String) -> void:
	peer.join_room(room_id)
	print("Joining room: ", room_id)
	await peer.room_connected
	print("Connected to room: ", room_id)
	connected_to_a_room.emit()
