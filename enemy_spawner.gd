extends Node
class_name EnemySpawner

@export var multiplayer_spawner: MultiplayerSpawner
@export var zombie_scene: PackedScene
@export var spawn_timer: Timer

#func _ready() -> void:
	#multiplayer_spawner.spawn_function = spawn_zombie

func begin_spawning() -> void:
	spawn_timer.start(0.25)
	#spawn_timer.timeout.connect(spawn_bunch)

#func spawn_bunch():
	#if not SessionManager.is_server():
		#return
	#
	#var player: PlayerBody = PlayerSpawner.I.get_game_player(1).player_body
	#var entity_id: int = EntityManager.I.get_next_entity_id()
	#
	#multiplayer_spawner.spawn({
		#"entity_id": entity_id,
		#"position": player.global_position + Vector2(0, 100)
	#})
	#spawn_timer.start(0.25)
#
#func spawn_zombie(data: Dictionary) -> Zombie:
	#var entity_id: int = data["entity_id"]
	#var position: Vector2 = data["position"]
	#
	#var zombie: Zombie = zombie_scene.instantiate()
	#zombie.entity_id = entity_id
	#zombie.global_position = position
	#return zombie
