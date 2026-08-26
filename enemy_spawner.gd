extends Node
class_name EnemySpawner

@export var multiplayer_spawner: MultiplayerSpawner
@export var zombie_scene: PackedScene
@export var spawn_timer: Timer

func _ready() -> void:
	multiplayer_spawner.spawn_function = spawn_zombie

func begin_spawning() -> void:
	spawn_timer.start(0.25)
	spawn_timer.timeout.connect(spawn_bunch)

func spawn_bunch():
	var zombie: Zombie = multiplayer_spawner.spawn(multiplayer.get_unique_id())
	var player: PlayerBody = GameMultiplayer.I.get_game_player(1).player_body
	zombie.global_position = player.global_position + Vector2(0, 100)
	spawn_timer.start(0.25)

func spawn_zombie(pid: int) -> Zombie:
	var zombie: Zombie = zombie_scene.instantiate()
	return zombie
