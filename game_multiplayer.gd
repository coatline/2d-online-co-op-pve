extends Node
class_name GameMultiplayer

static var I: GameMultiplayer

@export var player_spawn_position: Node2D
@export var player_scene : PackedScene
@export var player_spawner: MultiplayerSpawner

var pid_to_game_player: Dictionary[int, GamePlayer]

signal game_began

func _enter_tree() -> void:
	I = self

func _ready() -> void:
	player_spawner.spawn_function = _multiplayer_spawner_player

func spawn_player(authority_pid: int) -> void:
	var game_player: GamePlayer = player_spawner.spawn(authority_pid)
	game_player.setup(MultiplayerSessionManager.pid_to_network_player[authority_pid], player_spawn_position.global_position)

func _multiplayer_spawner_player(authority_pid: int) -> GamePlayer:
	#print("%d is spawning game player %d!" % [multiplayer.get_unique_id(), authority_pid])
	var game_player: GamePlayer = player_scene.instantiate()
	game_player.name = str(authority_pid)
	pid_to_game_player[authority_pid] = game_player
	return game_player

func get_game_player(pid: int):
	return pid_to_game_player[pid]

func get_game_players() -> Array[GamePlayer]:
	return GameMultiplayer.I.pid_to_game_player.keys()

@rpc("any_peer", "call_local", "reliable")
func start_game():
	if is_multiplayer_authority():
		GameMultiplayer.I.spawn_player(1)
		
		for peer in multiplayer.get_peers():
			GameMultiplayer.I.spawn_player(peer)

	game_began.emit()
