class_name ActionTimer
extends Node

signal Ready

var Duration := 10.0 
var Speed := 1.0

var _active := true
var _time := 0.0


func _process(delta):
	if !_active:
		return
	_time += delta * Speed
	if _time >= Duration:
		emit_signal("Ready")


func start_timer(init = 0.0):
	if _active:
		Logger.log_warning(self, "Timer already running.")
		return
	_time = init
	_active = true


func get_time_remaining() -> float:
	return Duration - _time


