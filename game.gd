extends Node2D
class_name Game

@export var enemy_spawner: EnemySpawner
@export var player_spawner: PlayerSpawner

var pid_to_game_player: Dictionary[int, GamePlayer] = {}

func _ready() -> void:
	SessionManager.network_session_state.game_state_changed.connect(_game_state_changed)

func _game_state_changed(state: NetworkSessionState.GameState) -> void:
	if not multiplayer.is_server():
		return
	
	if state == NetworkSessionState.GameState.GAME:
		player_spawner.spawn_player(1)
		
		for peer_id: int in multiplayer.get_peers():
			player_spawner.spawn_player(peer_id)
		
		enemy_spawner.begin_spawning()
