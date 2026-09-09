extends Node
# Autoload GameSynchronizer

@export var entity_type_to_scene: Dictionary[EntityState.EntityType, PackedScene]
var peer_id_to_player_id: Dictionary[int, int]


# Go ahead and spawn it, even if you are the client.
# If you are the client, send the request to the server
func server_only_spawn_player(user: UserState) -> void:
	# Get the next entity id
	var player_state: PlayerState = PlayerState.new()
	player_state.peer_id = user.peer_id
	
	player_state.id = EntityManager.I.get_next_entity_id()

	# Spawn in the entity
	GameSimulation.I.spawn_entity_node(player_state)
	
	peer_id_to_player_id[user.peer_id] = player_state.id


func get_player_id_from_peer(peer_id: int) -> int:
	return peer_id_to_player_id.get(peer_id, -1)


func server_only_despawn_player(peer_id: int) -> void:
	var player_id: int = get_player_id_from_peer(peer_id)

	if player_id == -1:
		return

	var player_node: GamePlayer = EntityManager.I.get_entity(player_id)
	player_node.queue_free()
	EntityManager.I.unregister_entity(player_id)
	peer_id_to_player_id.erase(peer_id)


func spawn_entity(entity_state: EntityState) -> void:
	# Check if we already have an entity with that id (if so, change it to the next one)
	if EntityManager.I.entities.has(entity_state.id) or entity_state.id == -1:
		entity_state.id = EntityManager.I.get_next_entity_id()

	# Spawn the entity in the world
	GameSimulation.I.spawn_entity_node(entity_state)
	
	if ConnectionManager.is_server() == false:
		var binary_writer: BinaryWriter = BinaryWriter.new()
		entity_state.serialize(binary_writer)
		request_spawn_rpc.rpc_id(1, binary_writer.get_data())


@rpc("any_peer", "call_remote", "reliable")
func request_spawn_rpc(requested_entity_state: PackedByteArray) -> void:
	var binary_reader: BinaryReader = BinaryReader.new(requested_entity_state)
	var entity_type: int = binary_reader.read_u8()
	var entity_id: int = binary_reader.read_u32()
	
	var new_entity_state: EntityState = create_entity(entity_type)
	new_entity_state.id = entity_id
	new_entity_state.entity_type = entity_type
	new_entity_state.deserialize(binary_reader)

	spawn_entity(new_entity_state)

func create_entity(entity_type: int) -> EntityState:
	match entity_type:
		EntityState.EntityType.PLAYER:
			return PlayerState.new()
		EntityState.EntityType.PROJECTILE:
			return ProjectileState.new()
	return EntityState.new()



#  update_world_state (entity sync)
#├── spawn_entity / despawn_entity RPCs
#└── tick synchronization
