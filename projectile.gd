extends Node2D
class_name Projectile

@export var damage_dealer: DamageDealer
@export var hit_box: Hitbox

var force: Vector2

func setup(_source_entity: Entity, _force: Vector2) -> void:
	if _source_entity == null:
		push_error("source entity null!")
	damage_dealer.setup(_source_entity, 10, force.length())
	damage_dealer.source_entity = _source_entity
	force = _force

func _ready() -> void:
	if multiplayer.is_server() == false:
		hit_box.queue_free()
		return
	
	get_tree().create_timer(1.5).timeout.connect(queue_free)
	hit_box.damaged_entity.connect(queue_free)

func _physics_process(delta: float) -> void:
	if multiplayer.is_server() == false:
		return
	
	global_position += force * delta
	#global_position += global_transform.x * speed * delta
