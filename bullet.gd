extends Area2D
class_name Bullet

@export var speed: float = 100

func _ready() -> void:
	get_tree().create_timer(1.5).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	global_position += global_transform.x * speed * delta
