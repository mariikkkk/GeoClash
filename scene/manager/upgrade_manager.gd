## Менеджер улучшений (апгрейдов).[br]
## Отвечает за выдачу карточек при повышении уровня, выбор случайных апгрейдов,
## учёт их количества и применение эффектов к игроку и его атакам.
extends Node
class_name UpgradeManager

## Менеджер опыта — вызывает апгрейды при lvl_up.
@export var exp_manager: ExperienceManager

## UI-экран выбора карточек.
@export var upgrade_ui: UpgradeScreen

## Полный пул доступных улучшений.
@export var upgrade_pool: Array[AbilityUpgrade] = []

## Количество карточек, показываемых за каждый уровень.
@export var cards_per_level: int = 3

## Звук повышения уровня.
@onready var lvl_up_sound = $lvl_up_sound

## Ссылка на игрока.
var player: Node2D


var sword_attack: Node ## Ссылка на атаку мечом.
var orbital_attack: Node ## Ссылка на атаку сферами.

## Учёт взятых апгрейдов по id.
## Пример: { "damage_up": {"upgrade": <AbilityUpgrade>, "quantity": 2} }
var current_upgrades: Dictionary = {}


## Проверяет, можно ли взять апгрейд (учёт max_quantity).
##
## [param upgrade] — проверяемый апгрейд.
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


## Инициализация менеджера, подключение сигналов и поиск игрока.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D
	if player:
		orbital_attack = player.get_node("AttackManager/OrbitalAttackController")
		sword_attack   = player.get_node("AttackManager/AttackContoller")

	if exp_manager:
		exp_manager.lvl_up.connect(_on_level_up)

	if upgrade_ui:
		upgrade_ui.card_chosen.connect(_on_card_chosen)
		upgrade_ui.visible = false


## Реакция на повышение уровня — показывает выбор апгрейдов.
##
## [param _current_level] — уровень (пока не используется).
func _on_level_up(_current_level: int) -> void:
	if upgrade_pool.is_empty():
		return

	get_tree().paused = true

	var candidates: Array[AbilityUpgrade] = upgrade_pool.duplicate()
	var chosen: Array[AbilityUpgrade] = _pick_random_upgrades(candidates, cards_per_level)

	if upgrade_ui:
		upgrade_ui.show_cards(chosen)
		upgrade_ui.visible = true


## Выбирает случайные апгрейды из списка с учётом ограничения max_quantity.
##
## [param source] — пул доступных апгрейдов.[br]
## [param count] — сколько нужно выбрать.
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


## Обрабатывает выбор игроком карточки.
##
## [param upgrade] — выбранный апгрейд.
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


## Применяет эффект выбранного апгрейда к игроку или атакам.
##
## [param upgrade] — выбранный апгрейд.
func _apply_upgrade_effect(upgrade: AbilityUpgrade) -> void:
	if player == null:
		return

	match upgrade.upgrade_type:

		"damage":
			sword_attack.sword_damage += upgrade.value

		"speed":
			player.max_speed *= 1 + upgrade.value

		"hp":
			player.health_component.max_health += upgrade.value
			player.health_component.current_health = player.health_component.max_health
			GameSoundManager.play_hp_recovery()

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

		"pickup_range":
			player.increase_pickup_radius(1 + upgrade.value)

		_:
			print("Upgrade applied: ", upgrade.id, " (type: ", upgrade.upgrade_type, ")")
