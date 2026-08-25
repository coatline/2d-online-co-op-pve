extends Node
class_name Game

func start_game():
	# Spawn host
	GameMultiplayer.I.spawn_player(1)
	
	for peer in multiplayer.get_peers():
		GameMultiplayer.I.spawn_player(peer)
