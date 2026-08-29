extends Node
class_name GamePlayer

@export var camera_2d: Camera2D
@export var username_label: Label
@export var player_body: PlayerBody
@export var ui: Control

var peer_id: int
var spawn_position: Vector2

func initialize(user_state: UserState):
	username_label.text = user_state.username

func receive_packet(player_state: PlayerState):
	player_body.velocity = player_state.velocity
	player_body.global_position = player_state.position
	player_body.rotation_degrees = player_state.rotation_degrees
	pass

func _ready() -> void:
	set_multiplayer_authority(peer_id)
	
	player_body.set_multiplayer_authority(peer_id)
	username_label.position.x = -username_label.size.x / 2
	player_body.global_position = spawn_position
	
	print("[%d] is setting up player %d" % [multiplayer.get_unique_id(), peer_id])
	
	if peer_id != multiplayer.get_unique_id():
		camera_2d.queue_free()
	else:
		NetworkLogger.I.print_networked("I have the camera!")
		#username_label.hide()
		camera_2d.make_current()

func _process(_delta: float) -> void:
	ui.global_position = player_body.global_position
	#var reference_pos = camera_2d.global_position if camera_2d else player_body.global_position
	#username_label.global_position = reference_pos - Vector2(username_label.size.x / 2.0, username_label.size.y + 10.0)
