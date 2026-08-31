extends Node
class_name VoiceChatter

@export var mic: TwoVoipMic
@export var speaker: TwoVoipSpeaker

func _ready() -> void:
	var mic_button: Button = Button.new()
	mic_button.toggle_mode = true

	var ptt_button: Button = Button.new()
	ptt_button.toggle_mode = true

	var vox_button: Button = Button.new()
	vox_button.toggle_mode = true

	var denoise_button: Button = Button.new()
	denoise_button.toggle_mode = true
	denoise_button.button_pressed = true

	var input_select: OptionButton = OptionButton.new()

	mic.initvoipmic(mic_button, input_select, ptt_button, vox_button, denoise_button, null)
	mic.setopusvalues(48000, 20, 1, 32000, 10, true)
	mic.microphone_gain = 1.0

	mic.transmitaudiopacket.connect(_on_mic_packet)
	mic.transmitaudiojsonpacket.connect(_on_mic_json)

	speaker.set_sinewave_out(false)

	var local_peer_id: int = multiplayer.get_unique_id()
	var owning_peer_id: int = get_parent().peer_id

	if local_peer_id == owning_peer_id:
		_enable_microphone()

func _enable_microphone() -> void:
	mic.miconbutton.button_pressed = true
	mic._on_miconbutton(true)

	mic.voxbutton.button_pressed = false
	mic._on_vox_toggled(false)

	mic.pttbutton.button_pressed = true

	print("[VoiceChat] Microphone enabled for peer ", multiplayer.get_unique_id())

func _on_mic_packet(packet: PackedByteArray, frame_count: int) -> void:
	_send_voice_packet_to_server.rpc_id(1, packet)

func _on_mic_json(json_bytes: Dictionary) -> void:
	var bytes: PackedByteArray = JSON.stringify(json_bytes).to_ascii_buffer()
	_send_voice_json_to_server.rpc_id(1, bytes)

@rpc("any_peer", "call_remote", "unreliable", 0)
func _send_voice_packet_to_server(packet: PackedByteArray) -> void:
	if not SessionManager.is_server():
		return

	var sender_id: int = multiplayer.get_remote_sender_id()

	#for network_player: NetworkPlayer in SessionManager.pid_to_network_player.values():
		#if network_player.peer_id == sender_id:
			#continue
#
		#network_player.voice_chat._receive_voice_packet.rpc_id(network_player.peer_id, packet)

@rpc("any_peer", "call_remote", "reliable", 0)
func _send_voice_json_to_server(json_bytes: PackedByteArray) -> void:
	if not SessionManager.is_server():
		return

	var sender_id: int = multiplayer.get_remote_sender_id()

	#for network_player: NetworkPlayer in SessionManager.pid_to_network_player.values():
		#if network_player.peer_id == sender_id:
			#continue
#
		#network_player.voice_chat._receive_voice_json.rpc_id(network_player.peer_id, json_bytes)

@rpc("authority", "call_remote", "unreliable", 0)
func _receive_voice_packet(packet: PackedByteArray) -> void:
	speaker.tv_incomingaudiopacket(packet)

@rpc("authority", "call_remote", "reliable", 0)
func _receive_voice_json(json_bytes: PackedByteArray) -> void:
	speaker.tv_incomingaudiopacket(json_bytes)
