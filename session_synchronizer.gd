extends Node
# Autoload SessionSynchronizer

# Server sends updates to clients
# Clients send updates to server

signal player_joined_game(peer_id: int)

func _ready() -> void:
	SessionManager.user_joined.connect(_user_joined)
	set_multiplayer_authority(multiplayer.get_unique_id())

func _user_joined(peer_id: int):
	if SessionManager.is_server() == false or peer_id == multiplayer.get_unique_id():
		return
	
	NetworkLogger.I.print_networked("Initializing the user %d's networking info" % peer_id)
	
	var writer: BinaryWriter = BinaryWriter.new()
	var user_state: UserState = SessionManager.try_get_user_state(peer_id)
	writer.write_header_u8(NetworkTransport.PacketType.INITIALIZE_CLIENT)
	user_state.serialize(writer)
	NetworkTransport.send_packet_to(writer.get_data(), peer_id)

@rpc("authority", "call_local", "reliable")
func all_set_game_started() -> void:
	SessionManager.begin_game()

@rpc("any_peer", "call_local", "reliable")
func all_join_this_player_in_game() -> void:
	SessionManager.peer_to_user_state[multiplayer.get_remote_sender_id()].in_game = true
	player_joined_game.emit(multiplayer.get_remote_sender_id())
