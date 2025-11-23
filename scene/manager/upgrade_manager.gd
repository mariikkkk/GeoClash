extends Node
class_name UpgradeManager

@export var exp_manager: ExperienceManager
@export var upgrade_ui: UpgradeScreen          
@export var upgrade_pool: Array[AbilityUpgrade] = []
@export var cards_per_level: int = 3
@onready var lvl_up_sound = $lvl_up_sound
var player: Node2D    
var sword_attack: Node
var orbital_attack: Node

var current_upgrades: Dictionary = {}

func _can_take_upgrade(upgrade: AbilityUpgrade) -> bool:
	if upgrade == null:
		return false

	if upgrade.max_quantity <= 0:
		return true

	var id := upgrade.id
	if not current_upgrades.has(id):
		return true

	var qty: int = current_upgrades[id].get("quantity", 0)
	return qty < upgrade.max_quantity


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D
	if player:
		orbital_attack = player.get_node("AttackManager/OrbitalAttackController")
		sword_attack = player.get_node("AttackManager/AttackContoller")
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

	var temp: Array[AbilityUpgrade] = []
	for u in source:
		if _can_take_upgrade(u):
			temp.append(u)

	while result.size() < count and temp.size() > 0:
		var idx := randi() % temp.size()
		var upgrade: AbilityUpgrade = temp[idx]
		result.append(upgrade)
		temp.remove_at(idx)

	return result


func _on_card_chosen(upgrade: AbilityUpgrade) -> void:
	if upgrade == null:
		return

	if not _can_take_upgrade(upgrade):
		if upgrade_ui:
			upgrade_ui.visible = false
		get_tree().paused = false
		return

	var id := upgrade.id
	if not current_upgrades.has(id):
		current_upgrades[id] = {
			"upgrade": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[id]["quantity"] += 1

	_apply_upgrade_effect(upgrade)

	if upgrade_ui:
		upgrade_ui.visible = false

	get_tree().paused = false


func _apply_upgrade_effect(upgrade: AbilityUpgrade) -> void:
	print("APPLY:", upgrade.id, "type:", upgrade.upgrade_type,
		  " orb_count:", orbital_attack.orb_count,
		  " rot_speed:", orbital_attack.rotation_speed)
	if player == null:
		return

	match upgrade.upgrade_type:
		"damage":
			sword_attack.sword_damage += upgrade.value
		"speed":
			player.max_speed *=  1 + upgrade.value
		"hp":
			player.health_component.max_health += upgrade.value
			player.health_component.current_health = player.health_component.max_health
		"speed_sword":
			sword_attack.attack_cooldown *= 1 - upgrade.value
		"size":
			sword_attack.sword_scale *= 1 + upgrade.value
		"sword_count":
			sword_attack.max_swords += upgrade.value
		"sword_range":
			sword_attack.attack_range *= 1 + upgrade.value
		"orb_count":
			orbital_attack.orb_count += upgrade.value
			orbital_attack.rebuild_orbs()
		"orb_speed":
			orbital_attack.rotation_speed *= 1 + upgrade.value
		"orb_damage":
			orbital_attack.orb_damage += upgrade.value
			orbital_attack.rebuild_orbs()
		"pick_up":
			player.increase_pickup_radius(1.0 + upgrade.value)
		_:
			print("Upgrade applied: ", upgrade.id, " (type: ", upgrade.upgrade_type, ")")
