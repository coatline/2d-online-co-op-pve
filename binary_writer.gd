extends RefCounted
class_name BinaryWriter

var data: PackedByteArray = PackedByteArray()

func write_header_u8(value: int) -> void:
	write_u8(value)

func write_u8(value: int) -> void:
	data.append(value)

func write_u16(value: int) -> void:
	var offset: int = data.size()
	data.resize(offset + 2)
	data.encode_u16(offset, value)

func write_u32(value: int) -> void:
	var offset: int = data.size()
	data.resize(offset + 4)
	data.encode_u32(offset, value)

func write_i32(value: int) -> void:
	var offset: int = data.size()
	data.resize(offset + 4)
	data.encode_s32(offset, value)

func write_float(value: float) -> void:
	var offset: int = data.size()
	data.resize(offset + 4)
	data.encode_float(offset, value)

func write_vector2(value: Vector2) -> void:
	write_float(value.x)
	write_float(value.y)

func write_string(value: String) -> void:
	var bytes: PackedByteArray = value.to_utf8_buffer()
	write_u16(bytes.size())
	write_bytes(bytes)

func write_bool(value: bool) -> void:
	write_u8(1 if value else 0)

func write_bytes(value: PackedByteArray) -> void:
	data.append_array(value)

func get_data() -> PackedByteArray:
	return data
