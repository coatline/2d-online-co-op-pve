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
	var player: PlayerBody = GameMultiplayer.I.get_game_player(1).player_body
	multiplayer_spawner.spawn({"position" : player.global_position + Vector2(0, 100)})
	spawn_timer.start(0.25)

func spawn_zombie(data: Dictionary) -> Zombie:
	var position: Vector2 = data["position"]
	
	var zombie: Zombie = zombie_scene.instantiate()
	zombie.global_position = position
	return zombie
