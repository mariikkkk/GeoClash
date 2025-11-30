## Ресурс улучшения способности.[br]
## Хранит данные карточки апгрейда: название, описание, значение и тип эффекта.
class_name AbilityUpgrade
extends Resource

## Уникальный идентификатор улучшения.
@export var id: String = ""

## Заголовок карточки.
@export var title: String = ""

## Описание эффекта.
@export var description: String = ""

## Иконка улучшения.
@export var icon: Texture2D

## Тип апгрейда (например, "damage", "speed", "orbs").
@export var upgrade_type: String = ""

## Величина эффекта улучшения.
@export var value: float = 0

## Цвет оформления карточки.
@export var color: Color = Color.RED

## Максимальное количество раз, которое можно выбрать (-1 = без ограничений).
@export var max_quantity: int = -1
