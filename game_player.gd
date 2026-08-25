extends Node
class_name GamePlayer

@export var camera_2d: Camera2D
@export var username_label: Label
@export var player_body: PlayerBody

var network_player: NetworkPlayer

func setup(_network_player: NetworkPlayer, _position: Vector2):
	network_player = _network_player
	
	player_body.set_multiplayer_authority(network_player.peer_id)
	set_multiplayer_authority(network_player.peer_id)
	username_label.text = network_player.username
	name = str(network_player.peer_id)
	player_body.global_position = _position
	
	if is_multiplayer_authority() == false:
		camera_2d.queue_free()

func _process(delta: float) -> void:
	username_label.global_position = player_body.global_position - Vector2(0, 10)
