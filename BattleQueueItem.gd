class_name BattleQueueItem
extends Resource


enum ActionTypes{
	ATTACK,
	HEAL,
	REVIVE,
	BOOST_COOL,
	HASTEN,
	SLOW,
	SLEEP,
	CONFUSE
}

var type : int


func get_reference(source:Creature, targets:Array) -> BattleQueueReference:
	var r = BattleQueueReference.new()
	r.source = source
	r.targets = targets
	return r
