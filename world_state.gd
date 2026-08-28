class_name WorldState

var tick: int
var entities: Array[EntityState] = []
var peer_to_player_view: Dictionary[int, PlayerView]

func serialize() -> Array:
	var data: Array = [tick]
	for entity: EntityState in entities:
		data.append(entity.serialize())
	return data
