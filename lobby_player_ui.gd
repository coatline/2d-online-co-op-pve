extends VBoxContainer
class_name LobbyPlayerUI

@export var username_label: Label
@export var character_texture_rect: TextureRect

func setup(user_state: UserState) -> void:
	username_label.text = user_state.username
