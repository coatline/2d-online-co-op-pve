extends Node
class_name FlowOrchestrator

static var I: FlowOrchestrator

@onready var game_scene: PackedScene = preload("uid://cvwkjv2rk8kj2")
@export var game_type_menu: GameTypeMenu
@export var lan_connection_menu: LANConnectionMenu
@export var online_connection_menu: OnlineConnectionMenu
@export var lobby_menu: LobbyMenu

signal joined_game()

var game: Game

func _enter_tree() -> void:
	I = self

func _ready() -> void:
	SessionManager.session_initialized.connect(_on_session_initialized)
	ConnectionManager.network_session_terminated.connect(_on_network_session_terminated)

func _on_session_initialized() -> void:
	SessionManager.session_state.get_my_user_state().spawned_in_game_changed.connect(_on_spawn_in_game_changed)

func _on_spawn_in_game_changed(value: bool) -> void:
	if value:
		game = game_scene.instantiate()
		get_tree().root.add_child(game)
		joined_game.emit()

func _on_network_session_terminated() -> void:
	if game:
		game.queue_free()
		# If we were in the game, we were not in the lobby, where we already automatically
		
		game_type_menu.open()
	elif lobby_menu.visible:
		lobby_menu.back()
