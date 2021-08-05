class_name BattleParty
extends Node

export(Array, NodePath) var Members : Array


func _ready():
	BattleManager.register_party(self)


func get_party_info() -> Dictionary:
	# provide any "public" info about the members of the party
	var info = {}
	for member in Members:
		var m = get_node(member)
		info[m] = m.get_info()
	return info
