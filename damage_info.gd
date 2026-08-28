extends RefCounted
class_name DamageInfo

var amount: float
var source_entity: Entity
var knockback: Vector2
var damage_type: int

func _init(damage_amount: float, _source_entity: Entity = null, damage_knockback: Vector2 = Vector2.ZERO, type: DamageType = DamageType.PHYSICAL) -> void:
	amount = damage_amount
	source_entity = _source_entity
	knockback = damage_knockback
	damage_type = type

enum DamageType {
	PHYSICAL
}
