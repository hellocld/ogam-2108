class_name BattlePartyAI
extends Node

export(NodePath) var Party : NodePath

var _party : BattleParty


func _ready():
	_party = get_node(Party) as BattleParty
	for creature in _party.get_party_info().keys():
		creature.connect("ReadyForAction", self, "_make_decision", [creature])


func _make_decision(creature:CreatureNode):
	print("Making decision for %s" % creature)
	# get battle info from BattleManager
	var enemy_parties = BattleManager.get_opposing_parties(_party)
	var selected_party = enemy_parties[0] as BattleParty
	var enemy_party_info = selected_party.get_party_info()
	# choose action based on provided info
	var target_keys = enemy_party_info.keys()
	var possible_targets = _get_living_targets(enemy_party_info) as Array
	if possible_targets.size() == 0:
		print("No targets available for %s" % creature.name)
		return
	possible_targets.shuffle()
	var target_enemy =  possible_targets[0] as CreatureNode
	creature.connect("DoBattleEvent", creature, "_attack", [target_enemy], CONNECT_ONESHOT)
	# queue action in BattleManager
	BattleManager.queue_event(creature, "DoBattleEvent")

func _get_living_targets(party:Dictionary) -> Array:
	var targets = []
	for target in party.keys():
		if party[target].is_alive:
			targets.append(target)
	return targets
