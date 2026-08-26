extends Node
class_name GamePlayer

@export var camera_2d: Camera2D
@export var username_label: Label
@export var player_body: PlayerBody

var network_player: NetworkPlayer

@rpc("authority", "call_local", "reliable")
func setup_rpc(authority_pid: int, _position: Vector2) -> void:
	print("%d is setting up player %d" % [multiplayer.get_unique_id(), authority_pid])
	network_player = SessionManager.pid_to_network_player[authority_pid]
	set_multiplayer_authority(authority_pid)
	player_body.set_multiplayer_authority(authority_pid)
	username_label.text = network_player.username
	name = str(authority_pid)
	player_body.global_position = _position
	
	if authority_pid != multiplayer.get_unique_id():
		camera_2d.queue_free()
	else:
		camera_2d.make_current()
		username_label.hide()

func _process(delta: float) -> void:
	username_label.global_position = player_body.global_position - Vector2(0, 10)
