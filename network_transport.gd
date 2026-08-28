extends Node
class_name NetworkTransport

@rpc("any_peer", "unreliable")
func command_move(direction: Vector2, tick: int) -> void:
	if not multiplayer.is_server():
		return
	var sender_id: int = multiplayer.get_remote_sender_id()
	GameSimulation.I.move(sender_id, direction, tick)

@rpc("any_peer", "reliable")
func command_attack(target_id: int, tick: int) -> void:
	if not multiplayer.is_server():
		return
	var sender_id: int = multiplayer.get_remote_sender_id()
	GameSimulation.I.attack(sender_id, target_id, tick)

@rpc("authority", "unreliable")
func receive_snapshot(snapshot: Dictionary) -> void:
	if multiplayer.is_server():
		return
	GameSimulation.I.apply_snapshot(snapshot)
