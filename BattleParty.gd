class_name BattleParty
extends Node


var members = []

func _ready():
	for child in get_children():
		if child is CreatureNode:
			members.append(child)
	BattleManager.register_party(self)


func get_party_info() -> Dictionary:
	# provide any "public" info about the members of the party
	var info = {}
	for member in members:
		info[member] = member.get_info()
	return info
