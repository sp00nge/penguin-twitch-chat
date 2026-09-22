extends Node

var socket = WebSocketPeer.new()
var last_state = WebSocketPeer.STATE_CLOSED
var listening = false

signal connected_to_server()
signal connection_closed()
signal packet_received() # WIP

func connect_to_url(url: String, tls_options: TLSOptions = null) -> int:
	# Start Connection
	var err = socket.connect_to_url(url, tls_options)
	
	if err != OK:
		push_error("unable to connect")
		#set_process(false)
		return err
		
	last_state = socket.get_ready_state()
	return OK

func send(packet: String) -> int:
	var data = packet.to_utf8_buffer()
	return socket.send(data)
	
func get_packet():
	if socket.get_available_packet_count() < 1:
		return null
		
	var is_string = socket.was_string_packet()
	var data = socket.get_packet()
	
	if is_string:
		var text_message = data.get_string_from_utf8()
		#print("Received Message: ", text_message)
		return text_message
	#else:
	#	print("Received Binary Packet: ", data)
	#	return data

func clear() -> void:
	socket = WebSocketPeer.new()
	last_state = socket.get_ready_state()

func get_socket() -> WebSocketPeer:
	return socket
	
func poll() -> void:
	if socket.get_ready_state() != socket.STATE_CLOSED:
		socket.poll()
	var state = socket.get_ready_state()
	
	if last_state != state:
		last_state = state
		if state == socket.STATE_OPEN:
			if !listening:
				socket.send_text("PASS oauth:justinfan12345")
				socket.send_text("NICK justinfan12345")
				socket.send_text("JOIN #asdfplk")
				listening = true
			connected_to_server.emit()
		elif state == socket.STATE_CLOSED:
			connection_closed.emit()
	while socket.get_ready_state() == socket.STATE_OPEN and socket.get_available_packet_count():
		packet_received.emit(get_packet())

func _process(_delta):
	poll()
