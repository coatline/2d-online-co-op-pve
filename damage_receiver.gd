extends Node
class_name DamageReceiver

signal damage_received(damage: DamageInfo)
signal damage_blocked(damage: DamageInfo)

@export var entity: Entity
@export var health: Health
var invincible: bool

func take_damage(damage: DamageInfo) -> void:
	if not SessionManager.is_server():
		return
	
	if invincible:
		damage_blocked.emit(damage)
		return
	
	health.damage(damage.amount)
	damage_received.emit(damage)
