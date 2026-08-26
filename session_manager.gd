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
	MultiplayerManager.hosted_room.connect(_on_peer_connected)
	MultiplayerManager.peer_connected.connect(_on_peer_connected)
	MultiplayerManager.peer_disconnected.connect(_on_peer_disconnected)
	MultiplayerManager.disconnected_from_network.connect(_on_network_disconnected)

func start_session() -> void:
	if not MultiplayerManager.is_connected_to_network():
		push_error("Cannot start session without a network connection.")
		return
	
	if MultiplayerManager.is_host:
		_spawn_player(multiplayer.get_unique_id())

func _on_peer_connected(peer_id: int) -> void:
	if not MultiplayerManager.is_host:
		print("[%d] is not the host, so we aren't going to spawn network player %d" % [multiplayer.get_unique_id(), peer_id])
		return
	
	_spawn_player(peer_id)

func _spawn_player(peer_id: int) -> void:
	if pid_to_network_player.has(peer_id):
		print("[%d] does not have the pid %d, so we aren't going to spawn network player" % [multiplayer.get_unique_id(), peer_id])
		return
	print("%d is spawning network player: %d" % [multiplayer.get_unique_id(), peer_id])
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

func start_game() -> void:
	if not MultiplayerManager.is_host:
		return
	print("peer %d is starting the game" % multiplayer.get_unique_id())
	network_session_state.game_state = NetworkSessionState.GameState.GAME

func return_to_lobby() -> void:
	if not MultiplayerManager.is_host:
		return
	
	network_session_state.game_state = NetworkSessionState.GameState.LOBBY

func get_network_player(peer_id: int) -> NetworkPlayer:
	return pid_to_network_player.get(peer_id)

func get_all_network_players() -> Array[NetworkPlayer]:
	return pid_to_network_player.values()

func _on_network_disconnected() -> void:
	current_room = ""
	network_session_state.game_state = NetworkSessionState.GameState.LOBBY
	
	for network_player in pid_to_network_player.values():
		if is_instance_valid(network_player):
			network_player.queue_free()
	
	pid_to_network_player.clear()
