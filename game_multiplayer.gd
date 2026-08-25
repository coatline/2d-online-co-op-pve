extends Node
class_name GameMultiplayer

static var I: GameMultiplayer

signal game_began

@export var player_spawn_position: Node2D
@export var player_scene: PackedScene
@export var player_spawner: MultiplayerSpawner

var pid_to_game_player: Dictionary[int, GamePlayer]

func _enter_tree() -> void:
	I = self

func _ready() -> void:
	player_spawner.spawn_function = _multiplayer_spawner_player

@rpc("any_peer", "call_local", "reliable")
func start_game():
	game_began.emit()
	if multiplayer.is_server():
		spawn_player(1)
		
		for peer in multiplayer.get_peers():
			spawn_player(peer)
			

func spawn_player(pid: int):
	var game_player: GamePlayer = player_spawner.spawn(pid)
	game_player.setup_rpc.rpc(pid, player_spawn_position.global_position + Vector2.ONE * randf_range(-3, 3))

func _multiplayer_spawner_player(authority_pid: int) -> GamePlayer:
	var game_player: GamePlayer = player_scene.instantiate()
	game_player.name = str(authority_pid)
	pid_to_game_player[authority_pid] = game_player
	return game_player

func get_game_player(pid: int):
	return pid_to_game_player[pid]

func get_game_players() -> Array[GamePlayer]:
	return GameMultiplayer.I.pid_to_game_player.keys()
