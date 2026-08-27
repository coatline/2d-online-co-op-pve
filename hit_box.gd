extends Area2D
class_name Hitbox

signal damaged_entity

@export var damage_dealer: DamageDealer

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _on_area_entered(other_area: Area2D) -> void:
	if not multiplayer.is_server():
		return
	if other_area is Hurtbox:
		damage_dealer.deal_damage(other_area as Hurtbox)
		damaged_entity.emit()

func _on_body_entered(body: Node2D) -> void:
	if not multiplayer.is_server():
		return
	if body is Hurtbox:
		damage_dealer.deal_damage(body as Hurtbox)
		damaged_entity.emit()
