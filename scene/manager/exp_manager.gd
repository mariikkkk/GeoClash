extends Node
class_name ExperienceManager

signal exp_update (current_experience: float, target_experience: float)
signal lvl_up(current_level) #срабатывает только при получении нового уровня

@export var current_exp = 0
@export var target_exp = 5
@export var target_after_lvlup = 5
@export var current_level = 1
<<<<<<< HEAD
@onready var lvl_up_sound = $lvl_up_sound
=======
>>>>>>> 3cea586b7d62fc6afe81fb11625c8fbf2d382d7d

func _ready():
	Global.exp_bottle_collected.connect(on_exp_bottle_collected)
	
func on_exp_bottle_collected(exp):
	current_exp = min(current_exp + exp, target_exp)
	exp_update.emit(current_exp, target_exp)
	
	if current_exp == target_exp:
<<<<<<< HEAD
		GameSoundManager.play_lvl_up()
=======
>>>>>>> 3cea586b7d62fc6afe81fb11625c8fbf2d382d7d
		current_level += 1
		current_exp = 0
		target_exp += target_after_lvlup
		exp_update.emit(current_exp, target_exp)
		lvl_up.emit(current_level)
