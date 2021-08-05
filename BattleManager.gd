extends Node

signal BattleEventDone

export(Resource) var CreatureA 
export(Resource) var CreatureB


var event_queue = []
var battle_parties = []

var creature_a : CreatureNode
var creature_b : CreatureNode
var rng


func _ready():
	randomize()
	rng = RandomNumberGenerator.new()
	connect("BattleEventDone", self, "cleanup_event")
	

func register_party(party:BattleParty):
	if !battle_parties.has(party):
		battle_parties.append(party)
	else:
		print("Warning: BattleManager alread has reference to party %s" % party)


func get_opposing_parties(party:BattleParty) -> Array:
	var op = battle_parties.duplicate()
	op.erase(party)
	return op


func queue_event(instigator:Node, event_signal:String):
	print("Queueing event %s for creature %s" % [event_signal, instigator])
	var e = BattleEvent.new()
	e.instigator = instigator
	e.event_signal = event_signal
	event_queue.append(e)
	if event_queue.size() == 1:
		execute_next_event()


func execute_next_event():
	print("Attemping to pop event...")
	if event_queue.size() <= 0:
		print("Queue empty.")
		return
	var e = event_queue.front() as BattleEvent
	print("Executing event %s on %s" % [e.event_signal, e.instigator])
	e.instigator.emit_signal(e.event_signal)


func cleanup_event():
	event_queue.pop_front()
	if event_queue.size() > 0:
		execute_next_event()

func remove_events_for_instigator(instigator:Node):
	for event in event_queue:
		if event.instigator == instigator:
			event_queue.erase(event)
		
