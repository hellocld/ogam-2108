class_name CreatureAction
extends Resource

signal Complete


func execute():
	_do_action()
	emit_signal("Complete")


func _do_action():
	pass
