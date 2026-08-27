extends Node
class_name DamageDealer

@export var damage: float = 10.0
@export var knockback: Vector2 = Vector2.ZERO
@export var hitbox: Area2D
@export var source: Node

func deal_damage(hurtbox: Hurtbox) -> void:
	if not multiplayer.is_server():
		return
	if hurtbox.damage_receiver == null:
		return
	var damage_info: DamageInfo = DamageInfo.new(damage, source, knockback, DamageInfo.DamageType.PHYSICAL)
	hurtbox.damage_receiver.take_damage(damage_info)
