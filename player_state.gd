class_name PlayerState
extends EntityState

var peer_id: int
var health: int
var velocity: Vector2

func _init() -> void:
	entity_type = EntityType.PLAYER

func serialize(writer: BinaryWriter) -> void:
	super.serialize(writer)
	writer.write_u32(peer_id)
	writer.write_u16(health)
	writer.write_vector2(velocity)

func deserialize(reader: BinaryReader) -> void:
	super.deserialize(reader)
	peer_id = reader.read_u32()
	health = reader.read_u16()
	velocity = reader.read_vector2()
