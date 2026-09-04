class_name UserState

var peer_id: int
var username: String
var joined_game: bool

func _init(peer_id: int, username: String) -> void:
	self.peer_id = peer_id
	self.username = username
	self.joined_game = false
