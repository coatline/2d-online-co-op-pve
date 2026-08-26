extends Node
class_name NetworkSessionState

@export var multiplayer_synchronizer: MultiplayerSynchronizer

enum GameState { LOBBY, GAME, RESULTS }

signal game_state_changed(state: GameState)

var game_state: GameState = GameState.LOBBY:
	set(value):
		if game_state == value:
			return
		
		game_state = value
		game_state_changed.emit(value)

func set_game_state(new_state: GameState) -> void:
	if not multiplayer.is_server():
		return
	
	game_state = new_state

func reset() -> void:
	if not multiplayer.is_server():
		return
	
	game_state = GameState.LOBBY

func _ready() -> void:
	var config: SceneReplicationConfig = SceneReplicationConfig.new()
	config.add_property(":game_state")
	config.property_set_replication_mode(":game_state", SceneReplicationConfig.REPLICATION_MODE_ON_CHANGE)
	multiplayer_synchronizer.replication_config = config
