class_name UserState

var peer_id: int
var username: String
var joined_game: bool

func serialize() -> Dictionary:
	var dict: Dictionary = {
		"peer_id" : peer_id,
		"username" : username,
		"joined_game" : joined_game
	}
	return dict

func deserialize(dict: Dictionary) -> void:
	peer_id = dict.peer_id
	username = dict.username
	joined_game = dict.joined_game
