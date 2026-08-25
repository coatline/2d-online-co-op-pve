extends Node
class_name NetworkPlayer

@export var multiplayer_synchronizer: MultiplayerSynchronizer
@export var voice_chatter: VoiceChatter

var peer_id: int
var join_order: int
var username: String
var is_ready: bool
var color: Color

func _ready() -> void:
	setup_sync()

func setup_sync():
	var config = SceneReplicationConfig.new()
	
	var props = [
		[".:username", SceneReplicationConfig.REPLICATION_MODE_ON_CHANGE],
		[".:is_ready", SceneReplicationConfig.REPLICATION_MODE_ON_CHANGE],
		[".:color", SceneReplicationConfig.REPLICATION_MODE_ON_CHANGE]
	]
	
	for i in props.size():
		var path = props[i][0]
		var mode = props[i][1]
		config.add_property(path)
		config.property_set_replication_mode(path, mode)
	
	multiplayer_synchronizer.replication_config = config

func setup(pid: int, _join_order: int):
	peer_id = pid
	name = str(peer_id)
	join_order = _join_order
	username = "Player %s" % str(join_order)
	set_multiplayer_authority(peer_id)
