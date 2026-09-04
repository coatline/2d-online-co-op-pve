class_name UserState

var peer_id: int
var in_game: bool
var username: String

func _init(_peer_id: int, _username: String) -> void:
	peer_id = _peer_id
	username = _username

func serialize(writer: BinaryWriter) -> void:
	writer.write_i32(peer_id)
	writer.write_bool(in_game)
	writer.write_string(username)

func deserialize(reader: BinaryReader) -> void:
	#peer_id = reader.read_i32()
	in_game = reader.read_bool()
	username = reader.read_string()
