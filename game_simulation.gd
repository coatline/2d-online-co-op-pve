extends Node
class_name GameSimulation

static var I: GameSimulation

@export var player_scene: PackedScene

var peer_id_to_player_state: Dictionary[int, PlayerState] = {}
var peer_id_to_player: Dictionary[int, GamePlayer]

var entity_id_to_entity: Dictionary[int, Entity]

func _enter_tree() -> void:
	I = self

func add_player(peer_id: int, position: Vector2) -> void:
	var player_scene: GamePlayer = player_scene.instantiate()
	var player: PlayerState = PlayerState.new()
	player.peer_id = peer_id
	player.position = position
	players[peer_id] = player
	player_scene.initialize(SessionManager.local_session_data)
	add_child(player_scene)

func remove_player(peer_id: int) -> void:
	players.erase(peer_id)

func process_move(peer_id: int, direction: Vector2) -> void:
	if not players.has(peer_id):
		return
	var player: PlayerState = players[peer_id]
	player.velocity = direction.normalized() * 200.0

func update_world_state() -> void:
	for player in players.values():
		snapshot[player.peer_id] = {"position": player.position, "velocity": player.velocity}
	return snapshot

func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		update_world_state()
		NetworkTransport.I.clients_update_world_state.rpc(SessionManager.session_state.world_state.serialize())
	else:
		pass
