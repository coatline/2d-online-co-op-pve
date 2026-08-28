extends CharacterBody2D
class_name PlayerView

var target_position: Vector2
var target_velocity: Vector2
var target_rotation: float

func apply_snapshot(position_value: Vector2, velocity_value: Vector2, rotation_value: float) -> void:
	target_position = position_value
	target_velocity = velocity_value
	target_rotation = rotation_value

func _physics_process(delta: float) -> void:
	global_position = global_position.lerp(target_position, 15.0 * delta)
	velocity = velocity.lerp(target_velocity, 15.0 * delta)
	rotation = lerp_angle(rotation, target_rotation, 15.0 * delta)
