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
	
	var hurt_box: Hurtbox = other_area as Hurtbox
	
	if hurt_box:
		if damage_dealer.entity.team == null:
			print(get_parent().name)
		if hurt_box.damage_receiver.entity.team == damage_dealer.entity.team:
			return
		damage_dealer.deal_damage(hurt_box)
		damaged_entity.emit()

func _on_body_entered(body: Node2D) -> void:
	if not multiplayer.is_server():
		return
	
	var hurt_box: Hurtbox = body as Hurtbox
	
	if hurt_box:
		if hurt_box.damage_receiver.entity.team == damage_dealer.entity.team:
			return
		damage_dealer.deal_damage(hurt_box)
		damaged_entity.emit()
