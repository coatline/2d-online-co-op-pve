class_name WorldState

var tick: int
var entities: Dictionary[int, EntityState]
var dictionary: Array[PlayerState]
var players: Array[PlayerState] = []

func serialize() -> Array:
	var data: Array = [tick]
	for entity: EntityState in entities:
		data.append(entity.serialize())
	return data

static func deserialize(arr: Array) -> WorldState:
	#tick = arr[0]
	return WorldState.new()
	#for i in range(1, arr.size()):
		#entities.
