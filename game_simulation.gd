extends Node
class_name GameSimulation

static var I: GameSimulation
#var commands: Array[]

func _init() -> void:
	I = self

func _physics_process(_delta: float) -> void:
	if multiplayer.is_server():
		pass
