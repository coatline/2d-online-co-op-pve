extends CharacterBody2D
class_name Zombie

@export var speed: float = 100.0

var target: Node2D

func _ready() -> void:
	if is_multiplayer_authority() == false:
		return
	
	while is_instance_valid(self):
		get_target()
		await get_tree().create_timer(randf_range(1.0, 2.0)).timeout

func _process(delta: float) -> void:
	if is_multiplayer_authority() == false:
		return
	
	velocity = (target.global_position - global_position).normalized() * speed
	move_and_slide()
	
	look_at(target.global_position)

func get_target():
	target = GameMultiplayer.I.get_game_players()[0].player_body
