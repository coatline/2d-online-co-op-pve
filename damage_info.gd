extends RefCounted
class_name DamageInfo

var amount: float
var source_id: int
var knockback: Vector2
var damage_type: int

func _init(damage_amount: float, damage_source_id: int = -1, damage_knockback: Vector2 = Vector2.ZERO, type: DamageType = DamageType.PHYSICAL) -> void:
	amount = damage_amount
	source_id = damage_source_id
	knockback = damage_knockback
	damage_type = type

enum DamageType {
	PHYSICAL
}
