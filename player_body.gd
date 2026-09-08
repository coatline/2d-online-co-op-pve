extends RapierCharacterBody2D
class_name PlayerBody

@export var speed: float = 250.0
@export var game_player: GamePlayer

func _ready() -> void:
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_ON

func _physics_process(delta: float) -> void:
	if game_player.peer_id == ConnectionManager.get_peer_id():
		var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		
		velocity = dir * speed
	
		var mouse_pos = get_global_mouse_position()
		look_at(mouse_pos)
	
	NetworkLogger.I.print_networked(str(velocity))
	move_and_slide()
