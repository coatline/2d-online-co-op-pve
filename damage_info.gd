extends RefCounted
class_name DamageInfo

var amount: float
var source: Node
var knockback: Vector2
var damage_type: int

func _init(damage_amount: float, damage_source: Node = null, damage_knockback: Vector2 = Vector2.ZERO, type: DamageType = DamageType.PHYSICAL) -> void:
	amount = damage_amount
	source = damage_source
	knockback = damage_knockback
	damage_type = type

enum DamageType {
	PHYSICAL
}
