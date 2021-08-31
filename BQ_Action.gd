class_name BQ_Action
extends BattleQueueItem

export(ActionTypes) var Action_Type


func get_reference(source:Creature, targets:Array) -> BattleQueueReference:
	var r = .get_reference(source, targets)
	r.action_type = Action_Type
	return r
