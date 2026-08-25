extends Node
class_name EnemySpawner

@export var multiplayer_spawner: MultiplayerSpawner
@export var zombie_scene: PackedScene
@export var spawn_timer: Timer

func _ready() -> void:
	if is_multiplayer_authority() == false:
		return
	
	multiplayer_spawner.spawn_function = spawn_zombie
	spawn_timer.start(0.1)
	spawn_timer.timeout.connect(spawn_bunch)

func spawn_bunch():
	var zombie = multiplayer_spawner.spawn()
	var player: PlayerBody = GameMultiplayer.I.get_game_player(1)
	zombie.global_position = player.global_position + Vector2(0, 10)
	spawn_timer.start(0.1)

func spawn_zombie() -> Zombie:
	var zombie: Zombie = zombie_scene.instantiate()
	return zombie
