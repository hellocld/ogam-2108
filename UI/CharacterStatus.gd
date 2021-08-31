extends Panel


export(NodePath) var Name_Label
export(NodePath) var HP_Bar
export(NodePath) var HP_Text
export(NodePath) var CP_Bar
export(NodePath) var CP_Text
export(NodePath) var Time_Bar

var name_label:Label
var hp:ProgressBar
var hp_text:Label
var cp:ProgressBar
var cp_text:Label
var time:ProgressBar


func _ready():
	name_label = get_node(Name_Label) as Label
	hp = get_node(HP_Bar) as ProgressBar
	hp_text = get_node(HP_Text) as Label
	cp = get_node(CP_Bar) as ProgressBar
	cp_text = get_node(CP_Text) as Label
	time = get_node(Time_Bar) as ProgressBar


func set_hp(curr_hp:int, max_hp:int):
	hp.max_value = max_hp
	hp.value = curr_hp
	hp_text.text = "%d/%d" % [curr_hp, max_hp]


func set_cp(curr_cp:int, max_cp:int):
	cp.max_value = max_cp
	cp.value = curr_cp
	cp_text.text = "%d/%d" % [curr_cp, max_cp]


func set_name(name:String):
	name_label.text = name


func set_char_active():
	# set name_label to selected color
	pass


func set_char_inactive():
	# set name_label to unselected color
	pass
