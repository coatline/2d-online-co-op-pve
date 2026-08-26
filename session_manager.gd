extends Node
# Autoload SessionManager

@export var network_player_scene: PackedScene
@export var player_spawner: MultiplayerSpawner
@export var network_session_state: NetworkSessionState

var pid_to_network_player: Dictionary[int, NetworkPlayer] = {}
var current_room: String = ""

signal player_joined(peer_id: int)
signal player_left(peer_id: int)

func _ready() -> void:
	player_spawner.spawn_function = _spawn_network_player
	ConnectionManager.hosted_room.connect(_on_hosted_room)
	ConnectionManager.peer_connected.connect(_on_peer_connected)
	ConnectionManager.peer_disconnected.connect(_on_peer_disconnected)
	ConnectionManager.disconnected_from_network.connect(_on_network_disconnected)

func start_session() -> void:
	if not ConnectionManager.is_connected_to_network():
		push_error("Cannot start session without a network connection.")
		return
	
	reset_session()
	
	network_session_state.set_game_state(NetworkSessionState.GameState.LOBBY)
	
	if ConnectionManager.is_host:
		_spawn_player(multiplayer.get_unique_id())

func _on_hosted_room(peer_id: int) -> void:
	current_room = ""
	start_session()

func _on_peer_connected(peer_id: int) -> void:
	if not ConnectionManager.is_host:
		return
	
	_spawn_player(peer_id)

func _spawn_player(peer_id: int) -> void:
	if pid_to_network_player.has(peer_id):
		return
	
	player_spawner.spawn(peer_id)

func _spawn_network_player(data: Variant) -> NetworkPlayer:
	var peer_id: int = int(data)
	var network_player: NetworkPlayer = network_player_scene.instantiate()
	var order: int = pid_to_network_player.size()
	
	network_player.name = str(peer_id)
	network_player.setup(peer_id, order)
	
	pid_to_network_player[peer_id] = network_player
	player_joined.emit(peer_id)
	
	print("Registered network player peer: ", peer_id)
	return network_player

func _on_peer_disconnected(peer_id: int) -> void:
	var network_player: NetworkPlayer = pid_to_network_player.get(peer_id)
	
	if network_player == null:
		return
	
	pid_to_network_player.erase(peer_id)
	
	if is_instance_valid(network_player):
		network_player.queue_free()
	
	player_left.emit(peer_id)

func end_session() -> void:
	for network_player in pid_to_network_player.values():
		if is_instance_valid(network_player):
			network_player.queue_free()
	
	pid_to_network_player.clear()
	current_room = ""

func reset_session() -> void:
	end_session()

func get_network_player(peer_id: int) -> NetworkPlayer:
	return pid_to_network_player.get(peer_id)

func get_all_network_players() -> Array[NetworkPlayer]:
	return pid_to_network_player.values()

func _on_network_disconnected() -> void:
	end_session()
