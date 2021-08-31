extends Node


func process_action(action:CreatureAction, source:Creature, targets:Array):
	match action.Action_Type:
		CreatureAction.ActionTypes.ATTACK:
			_attack(action, source, targets)
		CreatureAction.ActionTypes.HEAL:
			_heal(action, source, targets)
		_:
			pass


func _apply_damage(source:Creature, target:Creature, modifier:int, is_critical:=false):
	var damage = source.Stats.Attack_Power + (randi() % modifier)
	if is_critical:
		damage *= 2
		# Boost the source's cool points?
	target.HP -= damage


func _apply_healing(_source:Creature, target:Creature, action:CreatureAction):
	var healing = randi() % action.Modifier
	if !action.Data.has("Healing"):
		Logger.log_warning(action, "No Data field 'Healing'.")
	else:
		healing += action.Data["Healing"]
	target.HP += healing
	if target.HP > target.Stats.HP:
		target.HP = target.Stats.HP



func _attack(action:CreatureAction, source:Creature, targets:Array):
	# TODO: Return if game state is not Battle
	for target in targets:
		var roll = randi() % 20
		if roll == 20:
			_apply_damage(source, target, action.Modifier, true)
		elif roll + action.Source.Stats.Dexterity < target.Stats.Defense:
			# Missed!
			return
		else:
			_apply_damage(source, target, action.Modifier, target)


func _heal(action:CreatureAction, source:Creature, targets:Array):
	for target in targets:
		_apply_healing(source, target, action)


func _revive(action:CreatureAction):
	pass


func _boost_cool(action:CreatureAction):
	pass


func _hasten(action:CreatureAction):
	pass


func _slow(action:CreatureAction):
	pass


func _sleep(action:CreatureAction):
	pass


func _confuse(action:CreatureAction):
	pass


func _ice(action:CreatureAction):
	pass


func _fire(action:CreatureAction):
	pass


func _poison(action:CreatureAction):
	pass


func _electric(action:CreatureAction):
	pass


func _sonic(action:CreatureAction):
	pass
