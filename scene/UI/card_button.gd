## Кнопка выбора улучшения.[br]
## Показывает иконку, название и описание апгрейда, а при нажатии
## отправляет сигнал с выбранным улучшением.
extends Button
class_name CardButton

## Срабатывает при выборе карточки.
## [param upgrade] — выбранное улучшение.
signal selected(upgrade: AbilityUpgrade)

## Хранимый апгрейд.
var _upgrade: AbilityUpgrade

## Иконка карточки.
@onready var icon_texture: TextureRect = $MarginContainer/VBoxContainer/Icon

## Заголовок апгрейда.
@onready var name_label: Label = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/NameLabel

## Описание апгрейда.
@onready var desc_label: Label = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/DescLabel


## Настраивает карточку под переданный апгрейд.
##
## [param upgrade] — ресурс улучшения.
func setup(upgrade: AbilityUpgrade) -> void:
	_upgrade = upgrade
	icon_texture.texture = upgrade.icon
	name_label.text = upgrade.title
	desc_label.text = upgrade.description
	_set_card_color(upgrade.color)


## Настраивает визуальный стиль карточки (цвет, радиус скруглений, рамка).
##
## [param c] — цвет фона.
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


## Подключает обработчик нажатия и выводит ссылки на элементы.
func _ready() -> void:
	print(icon_texture, name_label, desc_label)
	pressed.connect(_on_pressed)


## Вызывает сигнал выбора апгрейда.
func _on_pressed() -> void:
	emit_signal("selected", _upgrade)
