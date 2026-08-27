extends RapierCharacterBody2D
class_name Zombie

@export var speed: float = 100.0
@export var character_body_2d: CharacterBody2D

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
	
	character_body_2d.velocity = (target.global_position - character_body_2d.global_position).normalized() * speed
	character_body_2d.move_and_slide()
	
	character_body_2d.look_at(target.global_position)

func get_target():
	var players: Array[GamePlayer] = PlayerSpawner.I.get_game_players()
	if players.is_empty() == false:
		target = players[0].player_body
