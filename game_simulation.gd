extends Node
class_name GameSimulation

static var I: GameSimulation

@export var entity_type_to_scene: Dictionary[EntityState.EntityType, PackedScene]
@export var player_scene: PackedScene

var peer_id_to_player_state: Dictionary[int, PlayerState] = {}
var peer_id_to_player: Dictionary[int, GamePlayer]

var entity_id_to_entity: Dictionary[int, Entity]

func _enter_tree() -> void:
	I = self

func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		if SessionManager.session_state.game_started:
			var world_state: WorldState = SessionManager.session_state.world_state
			synchronize_world_state(world_state)
			var writer: BinaryWriter = BinaryWriter.new()
			world_state.serialize(writer)
			NetworkTransport.I.clients_update_world_state.rpc(writer.get_data())
	else:
		pass

# Client only

func apply_world_snapshot(world_state: WorldState) -> void:
	for entity_id: int in world_state.entity_id_to_state.keys():
		var state: EntityState = world_state.entity_id_to_state[entity_id]
		if entity_id_to_entity.has(entity_id) == false:
			var new_entity: Entity = entity_type_to_scene[state.entity_type].instantiate()
			add_child(new_entity)
			
	#for entity_data: Array in world_state_data:
		#var entity_state: EntityState = EntityState.deserialize(entity_data)
		#apply_entity_state(entity_state)

# Server only

#func create_player(peer_id: int, position: Vector2) -> void:
	#var player_scene: GamePlayer = player_scene.instantiate()
	#var player: PlayerState = PlayerState.new()
	#player.peer_id = peer_id
	#player.position = position
	#
	#peer_id_to_player[peer_id] = player_scene
	#player_scene.initialize(SessionManager.session_state.get_user_state(peer_id).username, player)
	#add_child(player_scene)

func synchronize_world_state(world_state: WorldState) -> void:
	for entity: Entity in entity_id_to_entity.values():
		var state: EntityState = 
