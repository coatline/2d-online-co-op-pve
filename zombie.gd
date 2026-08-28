extends RapierCharacterBody2D
class_name Zombie

@export var speed: float = 100.0
@export var character_body_2d: CharacterBody2D

var target: Node2D
var entity_id: int = -1
var target_timer: float = 0.0

func _ready() -> void:
	if !is_multiplayer_authority():
		return

	get_target()

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority():
		return

	if target:
		character_body_2d.velocity = (target.global_position - character_body_2d.global_position).normalized() * speed

		character_body_2d.move_and_slide()
		character_body_2d.look_at(target.global_position)

	if target_timer <= 0:
		target_timer = randf_range(1.0, 2.0)
		get_target()
	else:
		target_timer -= delta


func get_target():
	var players: Array[GamePlayer] = PlayerSpawner.I.get_game_players()
	if players.is_empty() == false:
		target = players[0].player_body
