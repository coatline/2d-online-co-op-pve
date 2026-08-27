extends Node
class_name ProjectileManager

static var I: ProjectileManager

@export var multiplayer_spawner: MultiplayerSpawner
@export var projectile_scene: PackedScene

func _ready() -> void:
	I = self
	multiplayer_spawner.spawn_function = multiplayer_spawn

@rpc("any_peer", "call_remote", "reliable")
func _request_spawn(position: Vector2, direction: Vector2, source_id: int):
	spawn_projectile(position, direction, source_id)

func spawn_projectile(position: Vector2, direction: Vector2, source_id: int) -> void:
	if not multiplayer.is_server():
		_request_spawn.rpc()
		return
	
	var data: Dictionary = {"position" : position }
	#var data: Dictionary = {"position" : position, "direction" : direction, "source_id" : source_id}
	var projectile: Projectile = multiplayer_spawner.spawn(data)
	projectile.setup(source_id, direction)

func multiplayer_spawn(data: Dictionary) -> Projectile:
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.position = data["position"]
	#projectile.set("direction", direction)
	#projectile.set("source", source)
	return projectile
