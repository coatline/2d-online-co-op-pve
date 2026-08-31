extends Node
class_name Health

signal health_changed(current: float, maximum: float)
signal died

@export var maximum: float = 100.0
@export_group("Optional")
@export var destroy_on_death: bool = true
@export var root: Node
@export var current: int:
	set(value):
		if current == value:
			return
		current = value
		health_changed.emit(current, maximum)

func _ready() -> void:
	if SessionManager.is_server() == false:
		return
	
	current = maximum

func damage(amount: float) -> void:
	if amount <= 0.0:
		return
	
	current = maxf(current - amount, 0.0)
	health_changed.emit(current, maximum)
	if current <= 0.0:
		died.emit()
		if destroy_on_death:
			root.queue_free()
