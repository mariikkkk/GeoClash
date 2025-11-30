## Способность атаки мечом.[br]
## Создаёт хитбокс удара и добавляется в группу "sword_attack".
class_name SwordAttackAbility
extends Node2D

## Компонент хитбокса, наносящий урон врагам.
@onready var hit_box_component: HitBoxComponent = $HitBoxComponent


## Инициализация способности.
##
## Добавляет объект в группу "sword_attack".
func _ready():
	add_to_group("sword_attack")
