extends Node
class_name NetworkTransport

static var I: NetworkTransport

func _enter_tree() -> void:
	I = self

@rpc("any_peer", "unreliable")
func command_move(direction: Vector2) -> void:
	if not multiplayer.is_server():
		return
	var peer_id: int = multiplayer.get_remote_sender_id()
	GameSimulation.I.process_move(peer_id, direction)

@rpc("authority", "unreliable")
func receive_snapshot(snapshot: Dictionary) -> void:
	if multiplayer.is_server():
		return
	for peer_id in snapshot:
		var player_view: PlayerView = get_node_or_null("../Players/" + str(peer_id))
		if player_view != null:
			player_view.apply_snapshot(snapshot[peer_id])

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

func send_snapshot(snapshot: Dictionary) -> void:
	receive_snapshot.rpc(snapshot)
