extends Node
# MultiplayerSessionManager Autoload

enum ConnectionType { NONE, NODE_TUNNEL, LAN }

@export var network_player_scene: PackedScene
@export var player_spawner: MultiplayerSpawner
@export var lan_port: int = 7777

var pid_to_network_player: Dictionary[int, NetworkPlayer] = {}
var peer: MultiplayerPeer
var node_tunnel_peer: NodeTunnelPeer
var connection_type: ConnectionType = ConnectionType.NONE
var current_room: String = ""

func _ready() -> void:
	player_spawner.spawn_function = _spawn_network_player

func connect_to_relay() -> void:
	_disconnect_current_session()
	_connect_signals()
	node_tunnel_peer = NodeTunnelPeer.new()
	node_tunnel_peer.error.connect(_on_node_tunnel_error)
	node_tunnel_peer.connect_to_relay("us-east.nodetunnel.io:8080", "some game is cool23")
	peer = node_tunnel_peer
	multiplayer.multiplayer_peer = peer
	connection_type = ConnectionType.NODE_TUNNEL
	print("Authenticating...")
	await node_tunnel_peer.authenticated
	print("Authenticated!")

func _on_node_tunnel_error(error_message: String) -> void:
	push_error("NodeTunnel Error: " + error_message)

func host_new_room(is_public: bool, meta_data: String) -> String:
	if connection_type != ConnectionType.NODE_TUNNEL or node_tunnel_peer == null:
		push_error("Cannot host a NodeTunnel room without connecting to the relay first.")
		return ""
	
	node_tunnel_peer.host_room(is_public, meta_data)
	
	print("Hosting room")
	await node_tunnel_peer.room_connected
	print("Now hosting room: ", node_tunnel_peer.room_id)
	
	current_room = node_tunnel_peer.room_id
	player_spawner.spawn(multiplayer.get_unique_id())
	return current_room

func join_room(room_id: String) -> void:
	if connection_type != ConnectionType.NODE_TUNNEL or node_tunnel_peer == null:
		push_error("Cannot join a NodeTunnel room without connecting to the relay first.")
		return
	
	node_tunnel_peer.join_room(room_id)
	
	print("Joining room: ", room_id)
	await node_tunnel_peer.room_connected
	print("Connected to room: ", room_id)
	
	current_room = node_tunnel_peer.room_id

func host_lan(port: int = lan_port) -> void:
	_disconnect_current_session()
	_connect_signals()
	
	var lan_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var error: Error = lan_peer.create_server(port)
	if error != OK:
		push_error("Failed to host LAN game: " + str(error))
		return
	
	peer = lan_peer
	multiplayer.multiplayer_peer = peer
	connection_type = ConnectionType.LAN
	current_room = ""
	
	print("Hosting LAN game on port: ", port)
	player_spawner.spawn(multiplayer.get_unique_id())

func join_lan(address: String, port: int = lan_port) -> void:
	_disconnect_current_session()
	_connect_signals()
	
	var lan_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var error: Error = lan_peer.create_client(address, port)
	if error != OK:
		push_error("Failed to join LAN game: " + str(error))
		return
	
	peer = lan_peer
	multiplayer.multiplayer_peer = peer
	connection_type = ConnectionType.LAN
	current_room = ""
	
	print("Joining LAN game at ", address, ":", port)

func _connect_signals() -> void:
	if not multiplayer.peer_connected.is_connected(_on_peer_connected):
		multiplayer.peer_connected.connect(_on_peer_connected)
	if not multiplayer.peer_disconnected.is_connected(_on_peer_disconnected):
		multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func _on_peer_connected(id: int) -> void:
	if multiplayer.is_server():
		print("Peer connected: ", id)
		player_spawner.spawn(id)

func _on_peer_disconnected(id: int) -> void:
	if pid_to_network_player.has(id):
		var network_player: NetworkPlayer = pid_to_network_player[id]
		pid_to_network_player.erase(id)
		if is_instance_valid(network_player):
			network_player.queue_free()

func _spawn_network_player(pid: Variant) -> Node:
	var peer_id: int = int(pid)
	var order: int = pid_to_network_player.size()
	var network_player: NetworkPlayer = network_player_scene.instantiate()
	network_player.name = str(peer_id)
	network_player.setup(peer_id, order)
	pid_to_network_player[peer_id] = network_player
	print("Registered network player peer: %d" % peer_id)
	return network_player

func disconnect_from_session() -> void:
	if multiplayer.peer_connected.is_connected(_on_peer_connected):
		multiplayer.peer_connected.disconnect(_on_peer_connected)
	if multiplayer.peer_disconnected.is_connected(_on_peer_disconnected):
		multiplayer.peer_disconnected.disconnect(_on_peer_disconnected)
	
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()
	
	multiplayer.multiplayer_peer = null
	peer = null
	node_tunnel_peer = null
	connection_type = ConnectionType.NONE
	current_room = ""
	
	for network_player in pid_to_network_player.values():
		if is_instance_valid(network_player):
			network_player.queue_free()
	
	pid_to_network_player.clear()
	print("Disconnected from multiplayer session.")

func _disconnect_current_session() -> void:
	if multiplayer.multiplayer_peer != null:
		disconnect_from_session()

func _exit_tree() -> void:
	if multiplayer.multiplayer_peer != null:
		disconnect_from_session()
