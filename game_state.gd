extends Node
class_name GameState

var players: Array[]

GameState
{
	players
	enemies
	projectiles
	items
	world
}

Command
{
	player_id
	tick
	move_direction
	attack
	ability
}
