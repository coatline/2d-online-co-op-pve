extends Node
class_name NetworkLogger

static var I: NetworkLogger

func _init() -> void:
	I = self

func print_networked(message: String) -> void:
	if I == null:
		print("[0] %s" % message)
		return
	var mult_id: int = I.multiplayer.get_unique_id()
	print("[%d] %s" % [mult_id, message])
