extends Node
# Autoload GameSynchronizer

@export var entity_type_to_scene: Dictionary[EntityState.EntityType, PackedScene]
var peer_id_to_player: Dictionary[int, GamePlayer]

# Go ahead and spawn it, even if you are the client.
# If you are the client, send the request to the server
func server_only_spawn_player(user: UserState) -> void:
	# Get the next entity id
	var player_state: PlayerState = PlayerState.new()
	player_state.peer_id = user.peer_id
	
	player_state.id = EntityManager.I.get_next_entity_id()

	# Spawn in the entity
	GameSimulation.I.spawn_player_node(player_state)


@rpc("any_peer", "call_remote", "reliable")
func request_spawn(requested_entity_state: PackedByteArray) -> void:
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
#├── player_input RPCs
#├── game scene lifecycle (instantiate/cleanup)
#└── tick synchronization
