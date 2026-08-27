extends Node
class_name DamageReceiver

signal damage_received(damage: DamageInfo)
signal damage_blocked(damage: DamageInfo)

@export var health: Health
@export var invincible: bool = false

func take_damage(damage: DamageInfo) -> void:
	if not multiplayer.is_server():
		return
	
	if invincible:
		damage_blocked.emit(damage)
		return
	
	health.damage(damage.amount)
	damage_received.emit(damage)
