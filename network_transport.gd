extends Node
class_name NetworkTransport

func process_packets() -> void:
	while multiplayer.multiplayer_peer.get_available_packet_count() > 0:
		var packet: PackedByteArray = multiplayer.multiplayer_peer.get_packet()
		deserialize_packet(packet)

func serialize_packet(packet_type: int, data: Variant) -> PackedByteArray:
	var bytes: PackedByteArray = PackedByteArray()
	bytes.append(packet_type)
	bytes.append_array(var_to_bytes(data))
	return bytes

func deserialize_packet(packet: PackedByteArray) -> void:
	var packet_header: int = packet.decode_u8(0)
	var data: Variant = bytes_to_var(packet.slice(1))

	match packet_header:
		PacketHeader.COMMAND:
			handle_command(data)
		PacketHeader.SNAPSHOT:
			handle_snapshot(data)
		#PacketType.EVENT:
			#handle_event(data)

func handle_command(byte_array: PackedByteArray):
	pass

func handle_snapshot(byte_array: PackedByteArray):
	pass

enum PacketHeader{
	COMMAND,
	SNAPSHOT,
	EVENT
}
