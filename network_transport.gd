extends Node
# Autoload NetworkTransport

func _ready() -> void:
	multiplayer.peer_packet.connect(_on_peer_packet)

func _on_peer_packet(peer_id: int, packet: PackedByteArray) -> void:
	NetworkLogger.I.print_networked("Received packet %s from peer %d" % [packet, peer_id])
	deserialize_packet(packet)

func send_packet_all(packet: PackedByteArray):
	multiplayer.multiplayer_peer.set_target_peer(MultiplayerPeer.TARGET_PEER_BROADCAST)
	multiplayer.send_bytes(packet)

func send_packet_to(packet: PackedByteArray, target_peer_id: int) -> void:
	multiplayer.multiplayer_peer.set_target_peer(target_peer_id)
	multiplayer.send_bytes(packet)

func deserialize_packet(packet: PackedByteArray) -> void:
	var binary_reader: BinaryReader = BinaryReader.new(packet)
	var packet_header: int = binary_reader.read_u8()
	NetworkLogger.I.print_networked("Packet header: %d" % packet_header)

	#match packet_header:
		#PacketType.COMMAND:
			#handle_command(binary_reader)
		#PacketType.WORLD_UPDATE:
			#handle_world_update(binary_reader)
		#PacketType.INITIALIZE_CLIENT:
			#NetworkLogger.I.print_networked("Recieved info on initilized client")
			#var peer_id: int = binary_reader.read_i32()
			#var user_state: UserState = SessionManager.try_get_user_state(peer_id)
			#if user_state == null:
				#var in_game = binary_reader.read_bool()
				#user_state = UserState.new(peer_id, binary_reader.read_string())
				#user_state.spawned_in_game = in_game
				#SessionManager.join_user(user_state)
				#NetworkLogger.I.print_networked("OKAY JOINING USER")
			#else:
				#user_state.deserialize(binary_reader)
			#pass

func handle_command(reader: BinaryReader):
	pass

func handle_world_update(reader: BinaryReader):
	pass

enum PacketType {
	INITIALIZE_CLIENT,
	SPAWN,
	DESPAWN,
	COMMAND,
	WORLD_UPDATE,
	GAME_STARTED
}
