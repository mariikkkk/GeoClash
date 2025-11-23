extends Node
@onready var hitting_enemy = $HittingEnemy
@onready var lvl_up_sound = $LvlUpSound

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func play_hitting():
	hitting_enemy.play()

func play_lvl_up():
	lvl_up_sound.play()
