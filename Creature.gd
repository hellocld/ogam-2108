class_name Creature
extends Node

export(Resource) var Stats
export(Array) var Actions
export(NodePath) var AnimTree:NodePath


enum Status { 
	FINE,
	DEAD
}

var _status
var _anim_state_machine:AnimationNodeStateMachinePlayback

func _ready():
	var at = get_node(AnimTree) as AnimationTree
	_anim_state_machine = at["parameters/playback"] as AnimationNodeStateMachinePlayback


func get_available_actions() -> Array:
	return Actions


func get_status() -> int:
	return _status


func play_animation(anim:String):
	_anim_state_machine.travel(anim)
