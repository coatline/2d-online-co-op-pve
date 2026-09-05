class_name UserState

signal spawned_in_game_changed(value: bool)

var peer_id: int
var username: String
var _joined_game: bool = false

var joined_game: bool:
	get:
		return _joined_game
	set(value):
		if _joined_game == value:
			return
		_joined_game = value
		spawned_in_game_changed.emit(value)

func serialize() -> Dictionary:
	var dict: Dictionary = {
		"peer_id": peer_id,
		"username": username,
		"joined_game": joined_game
	}
	return dict

func deserialize(dict: Dictionary) -> void:
	peer_id = dict["peer_id"]
	username = dict["username"]
	joined_game = dict["joined_game"]
