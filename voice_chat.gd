extends Node2D

@export var voice_player: AudioStreamPlayer2D
@export var audio_listener_2d: AudioListener2D
@export var mic: AudioStreamPlayer

var buffer_size: int = 512
var capture_effect: AudioEffectCapture
var stream: AudioStreamGeneratorPlayback

func _ready() -> void:
	var bus: StringName = mic.bus
	var bus_index: int = AudioServer.get_bus_index(bus)
	capture_effect = AudioServer.get_bus_effect(bus_index, 0)

	if is_multiplayer_authority():
		mic.stream = AudioStreamMicrophone.new()
		mic.play()
		audio_listener_2d.make_current()
	else:
		mic.stop()
		var generator: AudioStreamGenerator = AudioStreamGenerator.new()
		generator.mix_rate = 48000
		voice_player.stream = generator
		voice_player.play()
		stream = voice_player.get_stream_playback()

	if multiplayer.get_unique_id() == 1:
		voice_player.stop()

func _process(_delta: float) -> void:
	if is_multiplayer_authority():
		check_mic()

func check_mic() -> void:
	buffer_size = capture_effect.get_frames_available()

	if buffer_size <= 0:
		return

	var voice_data: PackedVector2Array = capture_effect.get_buffer(buffer_size)
	send_voice.rpc(voice_data)
	capture_effect.clear_buffer()

@rpc("any_peer", "call_remote", "unreliable", 0)
func send_voice(data: PackedVector2Array) -> void:
	if is_multiplayer_authority() or stream == null or data.is_empty():
		return

	for frame: Vector2 in data:
		stream.push_frame(frame)
