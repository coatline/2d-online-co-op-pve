extends Node2D
class_name DamageDealer

@export var damage: float = 10.0
@export var knockback: float = 10
@export var entity: Entity

var entity_id: int = -1

func _ready() -> void:
	if entity:
		entity_id = entity.id

func deal_damage(hurtbox: Hurtbox) -> void:
	if not multiplayer.is_server():
		return
	if hurtbox.damage_receiver == null:
		return
	
	var damage_info: DamageInfo = DamageInfo.new(damage, entity_id, (global_position - hurtbox.global_position).normalized() * knockback, DamageInfo.DamageType.PHYSICAL)
	hurtbox.damage_receiver.take_damage(damage_info)
