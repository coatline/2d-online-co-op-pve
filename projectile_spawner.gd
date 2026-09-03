extends Node
class_name ProjectileManager

static var I: ProjectileManager

@export var multiplayer_spawner: MultiplayerSpawner
@export var projectile_scene: PackedScene

func _ready() -> void:
	I = self
	multiplayer_spawner.spawn_function = multiplayer_spawn

@rpc("any_peer", "call_remote", "reliable")
func _request_spawn(position: Vector2, direction: Vector2, source_entity_id: int):
	NetworkLogger.I.print_networked("Requesting to spawn a projectile")
	spawn_projectile(position, direction, EntityManager.I.get_entity(source_entity_id))

func spawn_projectile(position: Vector2, force: Vector2, source_entity: Entity) -> void:
	if not SessionManager.is_server():
		#_request_spawn.rpc(position, force, source_entity.id)
		return
	
	var data: Dictionary = { "position" : position }
	var projectile: Projectile = multiplayer_spawner.spawn(data)
	projectile.setup(source_entity, force)

func multiplayer_spawn(data: Dictionary) -> Projectile:
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.position = data["position"]
	#projectile.set("direction", direction)
	#projectile.set("source", source)
	return projectile
