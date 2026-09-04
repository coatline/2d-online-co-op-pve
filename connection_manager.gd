extends Node
# Autoload ConnectionManager

enum ConnectionType { NONE, NODE_TUNNEL, LAN }
enum SessionMode { SINGLEPLAYER, HOST, CLIENT }

@export var lan_port: int = 7777

var connection_type: ConnectionType = ConnectionType.NONE
var session_mode: SessionMode = SessionMode.SINGLEPLAYER
var node_tunnel_peer: NodeTunnelPeer
var peer: MultiplayerPeer
var current_room: String

signal connected_to_network
signal disconnected_from_network

signal joined_room()
signal hosted_room()
signal peer_connected(peer_id: int)
signal peer_disconnected(peer_id: int)
signal connection_failed

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func connect_to_relay() -> void:
	if is_online():
		disconnect_from_network()
	
	node_tunnel_peer = NodeTunnelPeer.new()
	node_tunnel_peer.error.connect(_on_node_tunnel_error)
	node_tunnel_peer.connect_to_relay("us-east.nodetunnel.io:8080", "some game is cool23")
	
	peer = node_tunnel_peer
	multiplayer.multiplayer_peer = peer
	connection_type = ConnectionType.NODE_TUNNEL
	
	print("Authenticating...")
	await node_tunnel_peer.authenticated
	print("Authenticated!")

func host_room(is_public: bool, meta_data: String) -> String:
	if connection_type != ConnectionType.NODE_TUNNEL or node_tunnel_peer == null:
		push_error("Cannot host a NodeTunnel room without connecting to the relay first.")
		return ""
	
	session_mode = SessionMode.HOST
	node_tunnel_peer.host_room(is_public, meta_data)
	
	print("Hosting room")
	await node_tunnel_peer.room_connected

	print("Now hosting room: ", node_tunnel_peer.room_id)
	current_room = node_tunnel_peer.room_id
	hosted_room.emit()
	return node_tunnel_peer.room_id

func join_room(room_id: String) -> void:
	if connection_type != ConnectionType.NODE_TUNNEL or node_tunnel_peer == null:
		push_error("Cannot join a NodeTunnel room without connecting to the relay first.")
		return
	
	session_mode = SessionMode.CLIENT
	node_tunnel_peer.join_room(room_id)
	
	print("Joining room: ", room_id)
	await node_tunnel_peer.room_connected
	
	current_room = room_id
	joined_room.emit(peer.get_unique_id())
	print("Connected to room: ", room_id)

func host_lan(port: int = lan_port) -> void:
	if is_online():
		disconnect_from_network()
	
	var lan_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var error: Error = lan_peer.create_server(port)
	
	if error != OK:
		push_error("Failed to host LAN game: " + str(error))
		return
	
	current_room = "LAN Game on port %d" % port
	peer = lan_peer
	multiplayer.multiplayer_peer = peer
	connection_type = ConnectionType.LAN
	session_mode = SessionMode.HOST
	hosted_room.emit()
	
	print("Hosting LAN game on port: ", port)

func join_lan(address: String, port: int = lan_port) -> void:
	if is_online():
		disconnect_from_network()
	
	var lan_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var error: Error = lan_peer.create_client(address, port)
	
	if error != OK:
		push_error("Failed to join LAN game: " + str(error))
		return
	
	current_room = "LAN Game at %s:%d" % [address, port]
	peer = lan_peer
	multiplayer.multiplayer_peer = peer
	connection_type = ConnectionType.LAN
	session_mode = SessionMode.CLIENT
	
	print("Joining LAN game at %s:%d..." % [address, port])

func disconnect_from_network() -> void:
	multiplayer.multiplayer_peer.close()
	
	multiplayer.multiplayer_peer = null
	peer = null
	node_tunnel_peer = null
	connection_type = ConnectionType.NONE
	session_mode = SessionMode.SINGLEPLAYER
	
	disconnected_from_network.emit()

func is_connected_to_network() -> bool:
	return multiplayer.multiplayer_peer != null

func _on_connected_to_server() -> void:
	if connection_type == ConnectionType.LAN and session_mode == SessionMode.CLIENT:
		joined_room.emit()
	
	NetworkLogger.I.print_networked("I connected to server.")
	connected_to_network.emit()

func _on_connection_failed() -> void:
	push_error("Failed to connect to server.")
	connection_failed.emit()

func _on_server_disconnected() -> void:
	NetworkLogger.I.print_networked("The server disconnected.")
	disconnected_from_network.emit()

func _on_peer_connected(peer_id: int) -> void:
	NetworkLogger.I.print_networked("Peer %d connected." % peer_id)
	peer_connected.emit(peer_id)

func _on_peer_disconnected(peer_id: int) -> void:
	NetworkLogger.I.print_networked("Peer %d disconnected." % peer_id)
	peer_disconnected.emit(peer_id)

func _on_node_tunnel_error(error_message: String) -> void:
	NetworkLogger.I.print_networked("NodeTunnel error: %s" % error_message)
	push_error("NodeTunnel error: %s" + error_message)

func is_online() -> bool:
	return peer != null

func is_server() -> bool:
	return session_mode == SessionMode.SINGLEPLAYER or session_mode == SessionMode.HOST

func get_peer_id() -> int:
	if peer and peer.get_connection_status() != peer.ConnectionStatus.CONNECTION_DISCONNECTED:
		return multiplayer.get_unique_id()
	else:
		return -1
