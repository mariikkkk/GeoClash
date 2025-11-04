extends Node

@export var exp_manager: ExperienceManager
@export var upgrade_pool: Array[AbilityUpgrade]
var current_upgrades = {}

func _ready():
	exp_manager.lvl_up.connect(on_lvl_up)
	
func on_lvl_up(current_level):
	var chosen_upgrade = upgrade_pool.pick_random() as AbilityUpgrade
	if chosen_upgrade == null:
		return
	var has_upgrade = current_upgrades.has(chosen_upgrade.id)
	if !has_upgrade:
		current_upgrades[chosen_upgrade.id] = {
			"upgrade": chosen_upgrade,
			"quantity": 1 #количество апргрейдов
		}
	else:
		current_upgrades[chosen_upgrade.id]["quantity"] += 1
