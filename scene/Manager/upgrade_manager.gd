extends Node
class_name UpgradeManager

@export var exp_manager: ExperienceManager
@export var upgrade_ui: UpgradeScreen          
var player: Node2D            
@export var upgrade_pool: Array[AbilityUpgrade] = []
@export var cards_per_level: int = 3
@export var sword_attack: Node

var current_upgrades: Dictionary = {}

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D
	if exp_manager:
		exp_manager.lvl_up.connect(_on_level_up)

	if upgrade_ui:
		upgrade_ui.card_chosen.connect(_on_card_chosen)
		upgrade_ui.visible = false
		
func _on_level_up(current_level: int) -> void:
	if upgrade_pool.is_empty():
		return
	get_tree().paused = true
	var candidates: Array[AbilityUpgrade] = upgrade_pool.duplicate()
	var chosen: Array[AbilityUpgrade] = _pick_random_upgrades(candidates, cards_per_level)

	if upgrade_ui:
		upgrade_ui.show_cards(chosen)
		upgrade_ui.visible = true
		
func _pick_random_upgrades(source: Array[AbilityUpgrade], count: int) -> Array[AbilityUpgrade]:
	var result: Array[AbilityUpgrade] = []
	var temp := source.duplicate()

	while result.size() < count and temp.size() > 0:
		var idx := randi() % temp.size()
		var upgrade: AbilityUpgrade = temp[idx]
		result.append(upgrade)
		temp.remove_at(idx)

	return result

func _on_card_chosen(upgrade: AbilityUpgrade) -> void:
	if upgrade == null:
		return

	var id := upgrade.id

	# обновляем словарь текущих апгрейдов
	if not current_upgrades.has(id):
		current_upgrades[id] = {
			"upgrade": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[id]["quantity"] += 1

	# применяем эффект к игроку
	_apply_upgrade_effect(upgrade)

	# закрываем UI и снимаем паузу
	if upgrade_ui:
		upgrade_ui.visible = false

	get_tree().paused = false

func _apply_upgrade_effect(upgrade: AbilityUpgrade) -> void:
	if player == null:
		return

	match upgrade.upgrade_type:
		"damage":
			sword_attack.sword_damage += upgrade.value
		"speed":
			player.max_speed *=  1 + upgrade.value
		"hp":
			
		"speed_sword":
			sword_attack.attack_cooldown *= 1 - upgrade.value
		"size":
			sword_attack.sword_scale *= 1 + upgrade.value
		"sword_count":
			sword_attack.max_swords += upgrade.value
		"sword_range":
			sword_attack.attack_range *= 1 + upgrade.value
		_:
			print("Upgrade applied: ", upgrade.id, " (type: ", upgrade.upgrade_type, ")")
