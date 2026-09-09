class_name EntityState
extends RefCounted

enum EntityType { PLAYER, ENEMY, PROJECTILE }

var id: int = -1
var entity_type: EntityType
var position: Vector2
var rotation_degrees: float

func serialize(writer: BinaryWriter) -> void:
	writer.write_u8(entity_type)
	writer.write_u32(id)
	writer.write_float(rotation_degrees)
	writer.write_vector2(position)

func deserialize(reader: BinaryReader) -> void:
	rotation_degrees = reader.read_float()
	position = reader.read_vector2()
