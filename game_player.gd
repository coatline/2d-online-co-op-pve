extends Entity
class_name GamePlayer

@export var camera_2d: Camera2D
@export var username_label: Label
@export var player_body: PlayerBody

var authority_pid: int
var spawn_position: Vector2
var network_player: NetworkPlayer

func _ready() -> void:
	set_multiplayer_authority(authority_pid)
	network_player = SessionManager.get_network_player(authority_pid)
	
	if network_player == null:
		push_error("Could not find NetworkPlayer for peer %d." % authority_pid)
		return
	
	player_body.set_multiplayer_authority(authority_pid)
	username_label.text = network_player.username
	player_body.global_position = spawn_position
	
	print("[%d] is setting up player %d" % [multiplayer.get_unique_id(), authority_pid])
	
	if authority_pid != multiplayer.get_unique_id():
		camera_2d.queue_free()
	else:
		camera_2d.make_current()
		username_label.hide()

func _process(_delta: float) -> void:
	username_label.global_position = player_body.global_position - Vector2(0, 10)
