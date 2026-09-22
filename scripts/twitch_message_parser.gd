extends Node

func parse_message(message: String) -> Dictionary:
	var result = {
		"Sender": "",
		"Type": "",
		"Channel": "",
		"Message": ""
	}
	
	var parsed_message = message.split(" ", true, 3)
	
	if parsed_message[0].begins_with(":") and parsed_message[0].contains("!"):
		var parse_sender = parsed_message[0].split("!")
		parsed_message[0] = parse_sender[0].trim_prefix(":")

	
	result["Sender"] = parsed_message[0]
	result["Type"] = parsed_message[1]
	result["Channel"] = parsed_message[2].trim_prefix("#")
	result["Message"] = parsed_message[3].trim_prefix(":").trim_suffix("\r\n")
	#result["Message"] = parsed_message[3]
	return result
