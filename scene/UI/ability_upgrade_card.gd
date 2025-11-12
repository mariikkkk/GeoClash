extends PanelContainer
class_name AbilityUpgradeCard

@onready var name_label = $NameLabel
@onready var description = $Description

func set_ability_upgrade (upgrade:AbilityUpgrade):
	name_label.text = upgrade.name
	description.tect = upgrade.descrpiption
