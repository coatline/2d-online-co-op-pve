extends Marker2D
class_name Gun

@export var bullet_scene: PackedScene

@rpc("any_peer", "call_local", "unreliable")
func shoot() -> void:
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.top_level = true
	add_child(bullet)
	bullet.position = global_position
	bullet.rotation = global_rotation

func _process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	
	if Input.is_action_just_pressed("shoot"):
		shoot.rpc()
