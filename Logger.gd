extends Node

enum LogLevels {
	INFO = 1,
	WARNING = 3,
	ERROR = 5,
}

func log_info(object : Object, message : String):
	print_debug(_get_formatted_message(object, message, LogLevels.INFO))


func log_warning(object : Object, message : String):
	push_warning(_get_formatted_message(object, message, LogLevels.WARNING))


func log_error(object : Object, message : String):
	push_error(_get_formatted_message(object, message, LogLevels.ERROR))


func _get_formatted_message(object : Object, message : String, level : int) -> String:
	var level_string = ""
	match level:
		LogLevels.WARNING:
			level_string = "Warning"
		LogLevels.ERROR:
			level_string = "Error"
		_:
			level_string = "Info"
	
	return "%s [%s] %s:\n\t%s" % [_get_timestamp(), level_string, object.name, message]



func _get_timestamp() -> String:
	var dt = OS.get_datetime()
	return "%04d-%02d-%02d %02d:%02d:%02d" % [dt["year"], dt["month"], dt["day"], dt["hour"], dt["minute"], dt["second"]]
