extends Node2D

func _ready() -> void:
	TwitchWS.connected_to_server.connect(_on_twitchws_connected_to_server)
	TwitchWS.connection_closed.connect(_on_twitchws_connection_closed)
	TwitchWS.packet_received.connect(_on_twitchws_packet_received)
	
	print("Connecting to server")
	TwitchWS.connect_to_url("wss://irc-ws.chat.twitch.tv:443")

func _on_twitchws_connected_to_server() -> void:
	print("connected")
	
func _on_twitchws_connection_closed() -> void:
	print("Connection closed")

func _on_twitchws_packet_received(packet: String) -> void:
	print("Received packet from the server: %s" % packet)
	if !packet.begins_with(":justinfan12345"):
		var msg_dict = TwitchMessageParser.parse_message(packet)
		print(msg_dict)
