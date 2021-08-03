extends Node

export(Resource) var CreatureA 
export(Resource) var CreatureB

var creature_a : Creature
var creature_b : Creature
var rng


func _ready():
	randomize()
	rng = RandomNumberGenerator.new()
	# Instance a timer per Creature
	var timer_a = Timer.new()
	var timer_b = Timer.new()
	timer_a.one_shot = true
	timer_b.one_shot = true
	timer_a.connect("timeout", self, "roll_for_attack", [CreatureA, CreatureB, timer_a])
	timer_b.connect("timeout", self, "roll_for_attack", [CreatureB, CreatureA, timer_b])
	add_child(timer_a)
	add_child(timer_b)
	timer_a.start(3)
	timer_b.start(2)
	

func roll_for_attack(attacker, target, timer):
	if attacker.HP <= 0:
		return # Can't attack if you're dead
	print("-- %s attacking %s --" % [attacker.Name, target.Name])
	var roll = randi() % 20
	print("Roll: %d" % roll)
	if roll == 1:
		print("%s: Critical miss!" % attacker.Name)
	elif roll == 20:
		print("%s: Critical hit!" % attacker.Name)
		apply_damage(attacker, target, true)
	elif roll + attacker.Dexterity < target.Defense:
		print("%s: Miss!" % attacker.Name)
	else:
		print("%s: Hit!" % attacker.Name)
		apply_damage(attacker, target)
	print("-- Attack done --\n\n")
	timer.start(3)


func apply_damage(attacker, target, crit=false):
	var damage = attacker.Attack_Power
	if crit:
		damage *= 2
	print("%s takes %d damage from %s" % [target.Name, damage, attacker.Name])
	target.HP -= damage
	# Handle death?
	if target.HP <= 0:
		print("%s is dead." % target.Name)

