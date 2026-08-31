extends Node
class_name NetworkTransport

static var I: NetworkTransport

func _enter_tree() -> void:
	I = self

func process_packets() -> void:
	# Always recieve packets
	while multiplayer.multiplayer_peer.get_available_packet_count() > 0:
		var packet: PackedByteArray = multiplayer.multiplayer_peer.get_packet()
		deserialize_packet(packet)

func serialize_packet(packet_type: int, data: Variant) -> PackedByteArray:
	var bytes: PackedByteArray = PackedByteArray()
	bytes.append(packet_type)
	bytes.append_array(var_to_bytes(data))
	return bytes

func deserialize_packet(packet: PackedByteArray) -> void:
	var binary_reader: BinaryReader = BinaryReader.new(packet)
	var packet_header: int = binary_reader.read_u8()

	match packet_header:
		PacketHeader.COMMAND:
			handle_command(binary_reader)
		PacketHeader.WORLD_UPDATE:
			handle_world_update(binary_reader)

func handle_command(reader: BinaryReader):
	pass

func handle_world_update(reader: BinaryReader):
	pass

enum PacketHeader{
	COMMAND,
	WORLD_UPDATE,
	GAME_STARTED
}
