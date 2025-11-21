extends CanvasLayer
class_name UpgradeScreen

@export var card_scene: PackedScene   

@onready var cards_container = $Control/CenterContainer/CardsContainer

signal card_chosen(upgrade: AbilityUpgrade)

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

func _on_card_selected(upgrade: AbilityUpgrade) -> void:
	emit_signal("card_chosen", upgrade)
