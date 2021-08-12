class_name CreatureNode
extends Spatial

signal DoAction
signal ReadyForAction
signal DoBattleEvent

signal DoDamageToTarget(target, damage)
signal DoCriticalDamageToTarget(target, damage)
signal DoMissTarget(target)
signal DoCriticalMissTarget(target)
signal DoTakeDamage(target)
signal DoDie(target)

export(Resource) var Stats
export(NodePath) var Animation_Tree : NodePath

var rng : RandomNumberGenerator
var HP : int
var CP : int
var _anim_state : AnimationNodeStateMachinePlayback
var _timer : Timer

func _ready():
	rng = RandomNumberGenerator.new()
	Stats = Stats as CreatureStats
	HP = Stats.HP
	CP = Stats.CP
	var at = get_node(Animation_Tree)
	_anim_state = at["parameters/playback"] as AnimationNodeStateMachinePlayback
	_timer = Timer.new()
	_timer.one_shot = true
	_timer.connect("timeout", self, "ready_for_action")
	add_child(_timer)
	start_initiative_timer(Stats.Initiative)


func start_initiative_timer(init:float = 0):
	if HP <= 0:
		return
	_timer.start(1.0 - init) 

"""
Get publicly available info on a creature for use by another creature
"""
func get_info() -> CreatureInfo:
	var i = CreatureInfo.new()
	i.current_hp = HP
	i.current_cp = CP
	i.is_alive = (HP > 0)
	return i

class CreatureInfo:
	var current_hp : int
	var current_cp : int
	var is_alive : bool


"""
Base attack for all creatures
"""
func _attack(target:CreatureNode):
	Logger.log_info(self, "%s attempts to attack %s." % [self.name, target.name])
	# Play attack animation
	_anim_state.travel("Attack")
	# Roll a d20
	var roll = randi() % 20
	Logger.log_info(self, "%s rolled a %d" % [self.name, roll])
	var conn_error
	if roll == 1:
		# Critical miss
		Logger.log_info(self, "%s critically misses %s" % [self.name, target.name])
		conn_error = connect("DoAction", self, "_critical_miss_target", [target], CONNECT_ONESHOT)
	elif roll == 20:
		# Critical hit
		Logger.log_info(self, "%s critically hits %s" % [self.name, target.name])
		conn_error = connect("DoAction", self, "_critical_hit_target", [target], CONNECT_ONESHOT)
	elif roll + Stats.Dexterity < target.Stats.Defense:
		# Miss
		Logger.log_info(self, "%s misses %s" % [self.name, target.name])
		conn_error = connect("DoAction", self, "_miss_target", [target], CONNECT_ONESHOT)
	else:
		# Hit
		Logger.log_info(self, "%s hits %s" % [self.name, target.name])
		conn_error = connect("DoAction", self, "_hit_target", [target], CONNECT_ONESHOT)

	# Rudimentary error handling
	if conn_error != OK:
		Logger.log_error(self, "Error while connecting DoAction signal: %d" % conn_error)


func _die():
	Logger.log_info(self, "%s has died." % self.name)
	# Remove all queued events from the BattleManager queue
	BattleManager.remove_events_for_instigator(self)
	# Play some die animation
	_anim_state.travel("Die")
	emit_signal("DoDie", self)


func _take_damage(damage:int):
	Logger.log_info(self, "%s taking %d damage" % [self.name, damage])
	if HP - damage <= 0:
		HP = 0
		_die()
	else:
		_anim_state.travel("TakeDamage")
		HP -= damage
		emit_signal("DoTakeDamage", self, damage, HP, Stats.HP)


"""
Called by the animation as a keyframe, this function
triggers whatever signal should occur following the attack.
"""
func do_action():
	emit_signal("DoAction")
	start_initiative_timer()

func ready_for_action():
	emit_signal("ReadyForAction")


func _critical_miss_target(target:CreatureNode):
	emit_signal("DoCriticalMissTarget", target)


func _miss_target(target:CreatureNode):
	emit_signal("DoMissTarget", target)


func _critical_hit_target(target:CreatureNode):
	emit_signal("DoCriticalDamageToTarget", target, Stats.Attack_Power * 2)
	target._take_damage(Stats.Attack_Power * 2)


func _hit_target(target:CreatureNode):
	target._take_damage(Stats.Attack_Power)
	emit_signal("DoDamageToTarget", target, Stats.Attack_Power)
