extends Node
class_name GamePlayer

@export var camera_2d: Camera2D
@export var username_label: Label
@export var player_body: PlayerBody

var peer_id: int
var spawn_position: Vector2
var network_player: NetworkPlayer

func _ready() -> void:
	set_multiplayer_authority(peer_id)
	network_player = SessionManager.get_network_player(peer_id)
	
	if network_player == null:
		push_error("Could not find NetworkPlayer for peer %d." % peer_id)
		return
	
	player_body.set_multiplayer_authority(peer_id)
	username_label.text = network_player.username
	player_body.global_position = spawn_position
	
	print("[%d] is setting up player %d" % [multiplayer.get_unique_id(), peer_id])
	
	if peer_id != multiplayer.get_unique_id():
		camera_2d.queue_free()
	else:
		NetworkLogger.I.print_networked("I have the camera!")
		#username_label.hide()
		camera_2d.make_current()

func _process(_delta: float) -> void:
	var reference_pos = camera_2d.global_position if camera_2d else player_body.global_position
	username_label.global_position = reference_pos - Vector2(username_label.size.x / 2.0, username_label.size.y + 10.0)
