extends RapierCharacterBody2D
class_name PlayerBody

@export var speed: float = 250.0

var movement: Vector2

func _ready() -> void:
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_ON

func _physics_process(_delta: float) -> void:
	velocity = movement * speed
	move_and_slide()
