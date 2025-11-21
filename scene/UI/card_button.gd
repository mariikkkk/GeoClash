extends Button
class_name CardButton

signal selected(upgrade: AbilityUpgrade)

var _upgrade: AbilityUpgrade
@onready var icon_texture: TextureRect = $MarginContainer/VBoxContainer/Icon
@onready var name_label: Label = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/NameLabel
@onready var desc_label: Label = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/DescLabel

func setup(upgrade: AbilityUpgrade) -> void:
	_upgrade = upgrade

	icon_texture.texture = upgrade.icon
	name_label.text = upgrade.title
	desc_label.text = upgrade.description
	_set_card_color(upgrade.color)

func _set_card_color(c: Color) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = c

	style.corner_radius_top_left = 16
	style.corner_radius_top_right = 16
	style.corner_radius_bottom_left = 16
	style.corner_radius_bottom_right = 16
	style.shadow_size = 10
	style.border_color = Color.BLACK
	style.border_width_bottom = 3
	style.border_width_left = 3
	style.border_width_right = 3
	style.border_width_top = 3

	add_theme_stylebox_override("normal", style)
	add_theme_stylebox_override("hover", style)
	add_theme_stylebox_override("pressed", style)

	style.bg_color = c
	
func _ready() -> void:
	print(icon_texture, name_label, desc_label)
	pressed.connect(_on_pressed)
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	emit_signal("selected", _upgrade)
