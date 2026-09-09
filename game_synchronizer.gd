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
	GameSimulation.I.spawn_player_node(player_state)
	
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
	var binary_writer: BinaryWriter = BinaryWriter.new()
	entity_state.serialize(binary_writer)
	request_spawn_rpc.rpc(binary_writer.get_buffer())

@rpc("any_peer", "call_remote", "reliable")
func request_spawn_rpc(requested_entity_state: PackedByteArray) -> void:
	var binary_reader: BinaryReader = BinaryReader.new(requested_entity_state)
	var new_entity_state: EntityState = EntityState.new()
	new_entity_state.deserialize(binary_reader)

	# Check if we already have an entity with that id (if so, change it to the next one)
	if EntityManager.I.entities.has(new_entity_state.id):
		new_entity_state.id = EntityManager.I.get_next_entity_id()

	# Spawn the entity in the world
	var entity: Entity = GameSimulation.I.spawn_player_node(new_entity_state)

	# Add the entity to the server's world state.
	EntityManager.I.register_entity(new_entity_state.id, entity)

#  update_world_state (entity sync)
#├── spawn_entity / despawn_entity RPCs
#└── tick synchronization
