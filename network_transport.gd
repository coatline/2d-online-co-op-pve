extends Node
class_name NetworkTransport

static var I: NetworkTransport

func _enter_tree() -> void:
	I = self

@rpc("any_peer", "call_remote", "unreliable")
func command_move(direction: Vector2) -> void:
	if not multiplayer.is_server():
		return
	var peer_id: int = multiplayer.get_remote_sender_id()
	GameSimulation.I.process_move(peer_id, direction)

@rpc("authority", "call_remote", "unreliable")
func clients_update_world_state(world_state_dict: Dictionary) -> void:
	
	pass

func deserialize_entity(data: Array) -> EntityState:
	var entity_type: int = data[0]
	match entity_type:
		EntityState.EntityType.PLAYER:
			return PlayerState.deserialize(data)
		#EntityState.EntityType.ENEMY:
			#return EnemyState.deserialize(data)
		#EntityState.EntityType.PROJECTILE:
			#return ProjectileState.deserialize(data)
	return EntityState.deserialize(data)
