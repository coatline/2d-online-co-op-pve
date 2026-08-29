class_name UserState

var peer_id: int
var in_game: bool
var username: String

func _init(_peer_id: int, _username: String) -> void:
	peer_id = _peer_id
	username = _username
