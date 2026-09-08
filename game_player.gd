extends Entity
class_name GamePlayer

@export var camera_2d: Camera2D
@export var username_label: Label
@export var player_body: PlayerBody
@export var ui: Control

var peer_id: int
var spawn_position: Vector2

func apply_state(entity_state: EntityState) -> void:
	super(entity_state)
	var player_state: PlayerState = entity_state as PlayerState
	username_label.text = SessionManager.try_get_user_state(player_state.peer_id).username
	peer_id = player_state.peer_id

func _ready() -> void:
	username_label.position.x = -username_label.size.x / 2
	player_body.global_position = spawn_position
	
	print("[%d] is setting up player %d" % [ConnectionManager.get_peer_id(), peer_id])
	
	if peer_id != ConnectionManager.get_peer_id():
		camera_2d.queue_free()
	else:
		NetworkLogger.I.print_networked("I have the camera!")
		#username_label.hide()
		camera_2d.make_current()

func _process(_delta: float) -> void:
	ui.global_position = player_body.global_position
	#var reference_pos = camera_2d.global_position if camera_2d else player_body.global_position
	#username_label.global_position = reference_pos - Vector2(username_label.size.x / 2.0, username_label.size.y + 10.0)
