extends Node
class_name GameSimulation

static var I: GameSimulation

var players: Dictionary[int, PlayerState] = {}

func _enter_tree() -> void:
	I = self

func add_player(peer_id: int, position: Vector2) -> void:
	var player: PlayerState = PlayerState.new()
	player.peer_id = peer_id
	player.position = position
	players[peer_id] = player

func remove_player(peer_id: int) -> void:
	players.erase(peer_id)

func process_move(peer_id: int, direction: Vector2) -> void:
	if not players.has(peer_id):
		return
	var player: PlayerState = players[peer_id]
	player.velocity = direction.normalized() * 200.0

func _physics_process(delta: float) -> void:
	if not multiplayer.is_server():
		return
	for player in players.values():
		player.position += player.velocity * delta
		player.velocity = Vector2.ZERO
	NetworkTransport.I.send_snapshot(create_snapshot())

func create_snapshot() -> Dictionary:
	var snapshot: Dictionary = {}
	for player in players.values():
		snapshot[player.peer_id] = {"position": player.position, "velocity": player.velocity}
	return snapshot
