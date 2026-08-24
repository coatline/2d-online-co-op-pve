extends CharacterBody2D
class_name Player

@export var speed: float = 250.0
@export var camera_2d: Camera2D
@export var username_label: Label

func _enter_tree() -> void:
	set_multiplayer_authority(int(name))
	username_label.text = name
	
	if is_multiplayer_authority() == false:
		camera_2d.queue_free()
		physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_ON

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = dir * speed
	move_and_slide()
	
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
