extends Node
class_name NetworkSessionState

@export var multiplayer_synchronizer: MultiplayerSynchronizer

enum GameState { LOBBY, GAME, RESULTS }

signal game_state_changed(state: GameState)

var game_state: GameState = GameState.LOBBY:
	set(value):
		if multiplayer.has_multiplayer_peer():
			print("[%d] setting value to %s" % [multiplayer.get_unique_id(), str(value)])
		if game_state == value:
			return
		
		game_state = value
		game_state_changed.emit(value)

func _ready() -> void:
	var config: SceneReplicationConfig = SceneReplicationConfig.new()
	var props: Array = [[".:game_state", SceneReplicationConfig.REPLICATION_MODE_ON_CHANGE]]
	
	for i: int in props.size():
		var path: String = props[i][0]
		var mode: int = props[i][1]
		config.add_property(path)
		config.property_set_replication_mode(path, mode)
	
	multiplayer_synchronizer.replication_config = config
