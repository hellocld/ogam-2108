extends Spatial


func _input(event):
	if event.is_action_pressed("ui_accept"):
		BattleManager.cleanup_event()