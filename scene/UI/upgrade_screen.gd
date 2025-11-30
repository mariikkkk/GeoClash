## Экран выбора улучшений.[br]
## Показывает набор карточек-апгрейдов и передаёт выбранный апгрейд наружу.
extends CanvasLayer
class_name UpgradeScreen

## Сцена карточки улучшения.
@export var card_scene: PackedScene

## Контейнер, в который добавляются карточки.
@onready var cards_container = $Control/CenterContainer/CardsContainer

## Срабатывает при выборе карточки.
## [param upgrade] — выбранное улучшение.
signal card_chosen(upgrade: AbilityUpgrade)


## Показывает список карточек-апгрейдов.
##
## [param upgrades] — массив доступных улучшений.
func show_cards(upgrades: Array[AbilityUpgrade]) -> void:
	# удалить старые карточки
	for child in cards_container.get_children():
		child.queue_free()

	if card_scene == null:
		push_warning("card_scene не задан в UpgradeScreen")
		return

	for upgrade in upgrades:
		var card: CardButton = card_scene.instantiate()
		cards_container.add_child(card)
		card.setup(upgrade)
		card.selected.connect(_on_card_selected)

	visible = true


## Передаёт наружу выбранный апгрейд.
func _on_card_selected(upgrade: AbilityUpgrade) -> void:
	emit_signal("card_chosen", upgrade)
