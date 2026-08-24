extends Node
class_name Game

@export var world: World
@export var lobby: Lobby

func _ready() -> void:
	lobby.started_game.connect(_spawn_players)

func _spawn_players() -> void:
	world.spawn_player(1)
	
	for peer in multiplayer.get_peers():
		world.spawn_player(peer)
