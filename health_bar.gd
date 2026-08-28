extends ProgressBar
class_name HealthBar

@export var health: Health

func _ready() -> void:
	health.health_changed.connect(_on_health_changed)

func _on_health_changed(current, max):
	value = current / max
