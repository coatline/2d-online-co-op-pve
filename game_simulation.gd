extends Node
class_name GameSimulation

static var I: GameSimulation

@export var entity_type_to_scene: Dictionary[EntityState.EntityType, PackedScene]

var peer_id_to_player_state: Dictionary[int, PlayerState] = {}
var peer_id_to_player: Dictionary[int, GamePlayer]
var world_state: WorldState

var entity_id_to_entity: Dictionary[int, Entity]

func _enter_tree() -> void:
	I = self
	world_state = WorldState.new()

func _physics_process(delta: float) -> void:
	if SessionManager.is_server():
		if SessionManager.game_started:
			update_world_state(world_state)
			var writer: BinaryWriter = BinaryWriter.new()
			world_state.serialize(writer)
			#NetworkTransport.I.clients_update_world_state.rpc(writer.get_data())
			print(writer.get_data())


func spawn_player(peer: int, player_state: PlayerState) -> void:
	var player: GamePlayer = entity_type_to_scene[EntityState.EntityType.PLAYER].instantiate()
	player.initialize(SessionManager.get_user_state(peer).username, player_state)
	add_child(player)

# Client only

func apply_world_state(world_state: WorldState) -> void:
	for entity_id: int in world_state.entity_id_to_state.keys():
		var state: EntityState = world_state.entity_id_to_state[entity_id]
		var entity: Entity = EntityManager.I.get_entity(entity_id)
		if entity == null:
			var new_entity: Entity = entity_type_to_scene[state.entity_type].instantiate()
			new_entity.id = entity_id
			add_child(new_entity)

# Server only

func update_world_state(world_state: WorldState) -> void:
	for entity: Entity in entity_id_to_entity.values():
		var state: EntityState = world_state.entity_id_to_state.get_or_add(entity.id, EntityState.new())
		state.position = entity.global_position
		state.rotation_degrees = entity.rotation_degrees
		state.velocity = entity.velocity
		state.rotation_degrees = entity.rotation_degrees
