extends Marker2D
class_name Gun

@export var entity: Entity
@export var bullet_scene: PackedScene

func _process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	
	if Input.is_action_just_pressed("shoot"):
		var direction: Vector2 = Vector2.RIGHT.rotated(global_rotation)
		ProjectileManager.I.spawn_projectile(global_position, direction, entity.id)
