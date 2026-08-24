extends Node2D
class_name World

@export var player_scene : PackedScene
@export var player_spawner: MultiplayerSpawner

func _ready() -> void:
	player_spawner.spawn_function = _multiplayer_spawner_player

func spawn_player(authority_peer_id: int) -> void:
	player_spawner.spawn(authority_peer_id)

func _multiplayer_spawner_player(authority_peer_id: int) -> Player:
	var player: Player = player_scene.instantiate()
	player.name = str(authority_peer_id)
	player.position = get_viewport_rect().size / 2
	return player
