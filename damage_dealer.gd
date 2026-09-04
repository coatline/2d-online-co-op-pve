extends Node2D
class_name DamageDealer

@export var damage: float = 10.0
@export var knockback: float = 10
@export var source_entity: Entity

func setup(_source_entity: Entity, _damage: float = damage, _knockback: float = knockback):
	source_entity = _source_entity
	damage = _damage
	knockback = _knockback

func deal_damage(hurtbox: Hurtbox) -> void:
	if not ConnectionManager.is_server():
		return
	if hurtbox.damage_receiver == null:
		return
	
	var damage_info: DamageInfo = DamageInfo.new(damage, source_entity, (global_position - hurtbox.global_position).normalized() * knockback, DamageInfo.DamageType.PHYSICAL)
	hurtbox.damage_receiver.take_damage(damage_info)
