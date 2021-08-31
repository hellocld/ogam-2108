class_name CreatureAction
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

export(String) var Name
export(ActionTypes) var Type
export(String) var Animation
export(Dictionary) var Data


func queue_for_battle(source:Creature, targets:Array):
	BattleManager.queue_item(get_anim_reference(source, targets))
	BattleManager.queue_item(get_action_reference(source, targets))


func get_anim_reference(source:Creature, targets:Array):
	var r = BattleQueueReference.new()
	r.source = source
	r.targets = targets
	r.data = Data
	r.animation = Animation
	return r


func get_action_reference(source:Creature, targets:Array):
	var r = BattleQueueReference.new()
	r.source = source
	r.targets = targets
	r.data = Data
	r.action_type = Type
	return r
