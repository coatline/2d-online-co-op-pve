extends UIMenu
class_name GameTypeMenu

@export var online_connection_menu: OnlineConnectionMenu
@export var lan_connection_screen: LANConnectionMenu
@export var lobby_menu: LobbyMenu

@export var singleplayer_button: Button
@export var online_button: Button
@export var lan_button: Button

func _ready() -> void:
	singleplayer_button.pressed.connect(_singleplayer_pressed)
	online_button.pressed.connect(_online_pressed)
	lan_button.pressed.connect(_lan_pressed)

func _singleplayer_pressed() -> void:
	close()
	SessionManager.session_state = SessionState.new()
	SessionManager.create_user(ConnectionManager.get_peer_id(), "Me")
	SessionManager.initialize_session()
	lobby_menu.open()
	#SessionSynchronizer.join_game()

func _online_pressed() -> void:
	online_connection_menu.open()

func _lan_pressed() -> void:
	lan_connection_screen.open()
