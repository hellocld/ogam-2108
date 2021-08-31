class_name BQ_Animation
extends BattleQueueItem

export(String) var Animation_Name


func get_reference() -> BattleQueueReference:
	var r = .get_reference()
	r.animation = Animation_Name
	return r
