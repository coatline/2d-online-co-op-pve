class_name BinaryReader
extends RefCounted

var data: PackedByteArray
var offset: int = 0

func _init(bytes: PackedByteArray) -> void:
	data = bytes

func read_u8() -> int:
	var value: int = data.decode_u8(offset)
	offset += 1
	return value

func read_u16() -> int:
	var value: int = data.decode_u16(offset)
	offset += 2
	return value

func read_u32() -> int:
	var value: int = data.decode_u32(offset)
	offset += 4
	return value

func read_i32() -> int:
	var value: int = data.decode_s32(offset)
	offset += 4
	return value

func read_float() -> float:
	var value: float = data.decode_float(offset)
	offset += 4
	return value

func read_vector2() -> Vector2:
	var x: float = read_float()
	var y: float = read_float()
	return Vector2(x, y)

func read_string() -> String:
	var length: int = read_u16()
	var bytes: PackedByteArray = read_bytes(length)
	return bytes.get_string_from_utf8()

func read_bool() -> bool:
	return read_u8() != 0

func read_bytes(length: int) -> PackedByteArray:
	var value: PackedByteArray = data.slice(offset, offset + length)
	offset += length
	return value
