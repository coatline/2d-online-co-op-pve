extends Node2D
class_name Game

@export var enemy_spawner: EnemySpawner
@export var player_spawn_position: Node2D

var pid_to_game_player: Dictionary[int, GamePlayer] = {}

func _ready() -> void:
	SessionSynchronizer.game_began.connect(_game_began)
	SessionSynchronizer.player_joined_game.connect(_player_joined_game)

func _player_joined_game(peer: int) -> void:
	if multiplayer.is_server():
		GameSimulation.I.add_player(peer, player_spawn_position.global_position + Vector2.ONE * randf_range(-3.0, 3.0))
		
func _game_began() -> void:
	enemy_spawner.begin_spawning()
