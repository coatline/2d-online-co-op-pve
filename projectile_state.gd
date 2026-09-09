extends EntityState
class_name ProjectileState

var source_entity_id: int
var lifetime: float
var damage: float
var force: float

func _init() -> void:
	entity_type = EntityType.PROJECTILE

func serialize(writer: BinaryWriter) -> void:
	super.serialize(writer)
	writer.write_u32(source_entity_id)
	writer.write_float(lifetime)
	writer.write_float(damage)
	writer.write_float(force)

func deserialize(reader: BinaryReader) -> void:
	super.deserialize(reader)
	source_entity_id = reader.read_u32()
	lifetime = reader.read_float()
	damage = reader.read_float()
	force = reader.read_float()
