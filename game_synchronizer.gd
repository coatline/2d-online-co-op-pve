extends Node
# Autoload GameSynchronizer

@export var entity_type_to_scene: Dictionary[EntityState.EntityType, PackedScene]
var peer_id_to_player: Dictionary[int, GamePlayer]

# Go ahead and spawn it, even if you are the client.
# If you are the client, send the request to the server
func spawn_player(player_state: PlayerState) -> void:
	# Get the next entity id
	var entity_id: int = EntityManager.I.get_next_entity_id()
	player_state.peer_id = ConnectionManager.get_peer_id()
	player_state.id = entity_id

	# Spawn in the entity
	var entity: Entity = GameSimulation.I.spawn_player_node(player_state)
	
	# Add to the world state
	EntityManager.I.register_entity(entity_id, entity)
	pass


@rpc("any_peer", "call_remote", "reliable")
func request_spawn(requested_entity_state: PackedByteArray) -> void:
	if ConnectionManager.is_server():
		# Spawn the entity in the world
		# Add the entity to the server's world state.
		# Check if we already have an entity with that id (if so, change it to the next one)
		var binary_reader: BinaryReader = BinaryReader.new()
		# requested_entity_state
		pass

#  update_world_state (entity sync)
#├── spawn_entity / despawn_entity RPCs
#├── player_input RPCs
#├── game scene lifecycle (instantiate/cleanup)
#└── tick synchronization
