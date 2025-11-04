extends CanvasLayer
class_name UpgradeScreen
@onready var card_container = $MarginContainer/CardContainer
@export var upgrade_card_scene: PackedScene

func set_ability_upgrades (upgrades: Array[AbilityUpgrade]):
	for upgrade in upgrades:
		var upgrade_card_instance = upgrade_card_scene.instantiate() as AbilityUpgradeCard
		card_container.add_child(upgrade_card_instance)
		upgrade_card_instance.set_ability_upgrade(upgrade)
