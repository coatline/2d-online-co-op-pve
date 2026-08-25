extends Node
# MultiplayerSessionManager Autoload

@export var network_player_scene: PackedScene = preload("res://network_player.tscn")
@export var player_spawner: MultiplayerSpawner

var pid_to_network_player: Dictionary[int, NetworkPlayer]
var peer: NodeTunnelPeer
var current_room: String

func _ready() -> void:
	connect_to_relay()
	
	player_spawner.spawn_function = _spawn_network_player
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func connect_to_relay() -> void:
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
	player_spawner.spawn(multiplayer.get_unique_id())
	return current_room

func join_room(room_id: String) -> void:
	peer.join_room(room_id)
	
	print("Joining room: ", room_id)
	await peer.room_connected
	print("Connected to room: ", room_id)
	
	current_room = peer.room_id
	# Spawner handles syncing existing host & client nodes automatically!

func _on_peer_connected(id: int) -> void:
	if multiplayer.is_server():
		print("Peer connected: ", id)
		player_spawner.spawn(id)

func _on_peer_disconnected(id: int) -> void:
	if pid_to_network_player.has(id):
		var node = pid_to_network_player[id]
		pid_to_network_player.erase(id)
		if is_instance_valid(node):
			node.queue_free()

func _spawn_network_player(pid: Variant) -> Node:
	var peer_id: int = pid
	var order: int = pid_to_network_player.size()
	
	var network_player: NetworkPlayer = network_player_scene.instantiate()
	network_player.name = str(peer_id)
	network_player.setup(peer_id, order)
	
	pid_to_network_player[peer_id] = network_player
	print("Registered network player peer: %d" % peer_id)
	return network_player
