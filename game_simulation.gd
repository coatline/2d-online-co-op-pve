extends Node
class_name GameSimulation

static var I: GameSimulation

@export var entity_type_to_scene: Dictionary[EntityState.EntityType, PackedScene]

var world_state: WorldState

func _enter_tree() -> void:
	I = self
	world_state = WorldState.new()

func _physics_process(delta: float) -> void:
	if ConnectionManager.is_server():
		update_world_state(world_state)
		#var writer: BinaryWriter = BinaryWriter.new()
		#world_state.serialize(writer)
		#NetworkTransport.I.clients_update_world_state.rpc(writer.get_data())
		#print(writer.get_data())
	#else:
		#apply_world_state(world_state)

func spawn_entity_node(entity_state: EntityState) -> Entity:
	var entity: Entity = entity_type_to_scene[entity_state.entity_type].instantiate()
	entity.apply_state(entity_state)
	add_child(entity)
	EntityManager.I.register_entity(entity.id, entity)
	return entity

#func spawn_player_node(player_state: PlayerState) -> GamePlayer:
	#var player: GamePlayer = entity_type_to_scene[EntityState.EntityType.PLAYER].instantiate()
	#player.apply_state(player_state)
	#add_child(player)
	#EntityManager.I.register_entity(player.id, player)
	#return player

# Client only

func apply_world_state(reader: BinaryReader) -> void:
	world_state.deserialize(reader)
	
	for entity_id: int in world_state.entity_id_to_state.keys():
		var state: EntityState = world_state.entity_id_to_state[entity_id]
		var entity: Entity = EntityManager.I.get_entity(entity_id)
		if entity == null:
			entity = spawn_entity_node(state)
			entity.apply_state(state)
			NetworkLogger.I.print_networked("Adding entity! %s %d %s" % [entity.name, entity.id, EntityManager.I.entities])
		
		entity.apply_state(state)

# Server only

func update_world_state(world_state: WorldState) -> void:
	for entity: Entity in EntityManager.I.entities.values():
		world_state.entity_id_to_state[entity.id] = entity.get_current_state()
		#world_state.entity_id_to_state.get_or_add(entity.id, EntityState.new()) = entity.get_current_state()
