extends Area2D
class_name Hitbox

signal damaged_entity

@export var damage_dealer: DamageDealer

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if not multiplayer.is_server():
		return
	if area is Hurtbox:
		damage_dealer.deal_damage(area as Hurtbox)
		damaged_entity.emit()
