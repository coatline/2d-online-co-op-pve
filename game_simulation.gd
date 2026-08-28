extends Node
class_name GameSimulation

var commands: Array[]

func _physics_process(_delta: float) -> void:
	if multiplayer.is_server():
		process_commands()
		simulate()
		replicate_state()
