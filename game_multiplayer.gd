extends Node
class_name GameMultiplayer

static var I: GameMultiplayer

@export var enemy_spawner: EnemySpawner
@export var player_spawn_position: Node2D
@export var player_scene: PackedScene
@export var player_spawner: MultiplayerSpawner

var pid_to_game_player: Dictionary[int, GamePlayer] = {}

func _enter_tree() -> void:
	I = self

func _ready() -> void:
	player_spawner.spawn_function = _multiplayer_spawn_player
	SessionManager.network_session_state.game_state_changed.connect(_game_state_changed)

func _game_state_changed(state: NetworkSessionState.GameState) -> void:
	if not multiplayer.is_server():
		return
	
	if state == NetworkSessionState.GameState.GAME:
		spawn_player(1)
		
		for peer_id: int in multiplayer.get_peers():
			spawn_player(peer_id)
		
		enemy_spawner.begin_spawning()

func spawn_player(pid: int) -> void:
	if not multiplayer.is_server():
		push_error("[%d] Is not the server and is trying to spawn a player." % multiplayer.get_unique_id())
		return
	
	var position: Vector2 = player_spawn_position.global_position + Vector2.ONE * randf_range(-3.0, 3.0)
	var data: Dictionary = {"pid": pid, "position": position}
	player_spawner.spawn(data)

@rpc("any_peer", "call_remote", "reliable")
func request_spawn_player(pid: int) -> void:
	if not multiplayer.is_server():
		return
	
	spawn_player(pid)

func _multiplayer_spawn_player(data: Dictionary) -> GamePlayer:
	var pid: int = int(data["pid"])
	var position: Vector2 = data["position"]
	var game_player: GamePlayer = player_scene.instantiate()
	
	game_player.name = str(pid)
	game_player.authority_pid = pid
	game_player.spawn_position = position
	
	pid_to_game_player[pid] = game_player
	
	return game_player

func get_game_player(pid: int) -> GamePlayer:
	return pid_to_game_player[pid]

func get_game_players() -> Array[GamePlayer]:
	return pid_to_game_player.values()
