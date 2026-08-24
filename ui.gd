extends CanvasLayer
class_name UI

@export var connection_manager: ConnectionManager
@export var lobby: Lobby

func _ready() -> void:
	connection_manager.started_joining.connect(switch_to_lobby)
	connection_manager.started_hosting.connect(switch_to_lobby)
	lobby.started_game.connect(func(): hide_child.rpc("Lobby"))
	lobby.quit_game.connect(_on_lobby_quit_game)

func switch_to_lobby() -> void:
	connection_manager.hide()
	lobby.show()

@rpc("call_local")
func hide_child(path: NodePath) -> void:
	get_node(path).hide()

func _on_lobby_quit_game():
	lobby.hide()
	connection_manager.show()
