class_name PlayerState
extends EntityState

var peer_id: int
var health: int

func _init() -> void:
	entity_type = EntityType.PLAYER

func serialize(writer: BinaryWriter) -> void:
	super.serialize(writer)
	writer.write_u32(peer_id)
	writer.write_u16(health)

func load(reader: BinaryReader) -> void:
	super.load(reader)
	peer_id = reader.read_u32()
	health = reader.read_u16()
