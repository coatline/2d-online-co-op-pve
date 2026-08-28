extends Node
# LocalWorldState Autoload

var local_session_state: SessionState

var entity_id_to_entity: Dictionary[int, Entity]
var peer_id_to_player: Dictionary[int, PlayerView]
var current_room: String
