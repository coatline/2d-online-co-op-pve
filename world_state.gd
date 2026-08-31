class_name WorldState
extends RefCounted

var tick: int = 0
var entity_id_to_state: Dictionary[int, EntityState] = {}

func serialize(writer: BinaryWriter) -> void:
	writer.write_u32(tick)
	writer.write_u16(entity_id_to_state.size())
	for entity: EntityState in entity_id_to_state.values():
		entity.serialize(writer)

func deserialize(reader: BinaryReader) -> void:
	tick = reader.read_u32()
	var entity_count: int = reader.read_u16()
	var received_ids: Dictionary[int, bool] = {}

	for i: int in entity_count:
		var entity_type: int = reader.read_u8()
		var entity_id: int = reader.read_u32()
		received_ids[entity_id] = true

		if not entity_id_to_state.has(entity_id):
			entity_id_to_state[entity_id] = create_entity(entity_type)

		var entity: EntityState = entity_id_to_state[entity_id]
		entity.deserialize(reader)

	for entity_id: int in entity_id_to_state.keys():
		if not received_ids.has(entity_id):
			entity_id_to_state.erase(entity_id)

func create_entity(entity_type: int) -> EntityState:
	match entity_type:
		EntityState.EntityType.PLAYER:
			return PlayerState.new()
		#EntityState.EntityType.ENEMY:
			#return EnemyState.new()
		#EntityState.EntityType.PROJECTILE:
			#return ProjectileState.new()
	return null
