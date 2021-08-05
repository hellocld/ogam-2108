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
		pop_next_event()


func pop_next_event():
	print("Attemping to pop event...")
	if event_queue.size() <= 0:
		print("Queue empty.")
		return
	var e = event_queue.pop_front() as BattleEvent
	print("Executing event %s on %s" % [e.event_signal, e.instigator])
	e.instigator.emit_signal(e.event_signal)


