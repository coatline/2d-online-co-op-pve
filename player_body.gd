extends RapierCharacterBody2D
class_name PlayerBody

@export var speed: float = 250.0

func _ready() -> void:
	if is_multiplayer_authority() == false:
		physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_ON

func _physics_process(delta: float) -> void:
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = dir * speed
	move_and_slide()
	
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
