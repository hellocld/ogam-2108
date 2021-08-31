extends Node

signal BattleEventDone

enum QueueTypes {
	ACTION,
	ANIMATION
}

export(Resource) var CreatureA 
export(Resource) var CreatureB


var event_queue = []
var battle_parties = []

#var creature_a : CreatureNode
#var creature_b : CreatureNode


func _ready():
	randomize()
	connect("BattleEventDone", self, "cleanup_event")


func queue_item(ref:BattleQueueReference):
	event_queue.push_back(ref)
	if event_queue.size() == 1:
		execute_next_event()


func execute_next_event():
	Logger.log_info(self, "Attemping to execute next queued event...")
	if event_queue.size() <= 0:
		Logger.log_info(self, "Queue empty.")
		return
	Logger.log_info(self, "Executing event.")
	var e = event_queue.front() as BattleQueueReference
	_handle_event(e)


func _handle_event(e:BattleQueueReference) -> void:
	match(e.type):
		QueueTypes.ANIMATION:
			play_creature_animation(e.source, e.animation)
		QueueTypes.ACTION:
			apply_creature_effect(e.source, e.targets)
		_:
			Logger.log_warning(self, "Unable to process BattleQueueReference of type %s" % e.type)


func _cleanup_event():
	event_queue.pop_front()
	if event_queue.size() > 0:
		execute_next_event()


func remove_events_for_source(source:Creature):
	for event in event_queue:
		if event.source == source:
			event_queue.erase(event)


func play_creature_animation(creature:Creature, animation:String):
	creature.play_animation(animation)


func apply_creature_effect(source, targets):
	pass

