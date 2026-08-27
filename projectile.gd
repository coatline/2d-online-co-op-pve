extends Node2D
class_name Projectile

@export var damage_dealer: DamageDealer
@export var speed: float = 100
@export var hit_box: Hitbox

var source_id: int
var direction: Vector2

func setup(_source_id: int, _direction: Vector2) -> void:
	damage_dealer.entity_id = source_id
	source_id = _source_id
	direction = _direction

func _ready() -> void:
	if multiplayer.is_server() == false:
		hit_box.queue_free()
		return
	
	get_tree().create_timer(1.5).timeout.connect(queue_free)
	hit_box.damaged_entity.connect(queue_free)

func _physics_process(delta: float) -> void:
	if multiplayer.is_server() == false:
		return
	
	global_position += direction * speed * delta
	#global_position += global_transform.x * speed * delta
