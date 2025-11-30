## Контроллер настройки FPS.[br]
## Синхронизирует выбранное значение в списке с глобальными настройками
## и обновляет ограничение FPS в движке.
extends OptionButton
class_name FPSControl

## Устанавливает текущий пункт списка в соответствии с сохранённым FPS.
func _ready():
	var target_fps = GlobalSettings.max_fps
	var index := -1

	for i in range(item_count):
		var text: String = get_item_text(i)
		var value := int(text.get_slice(" ", 0))
		if value == target_fps:
			index = i
			break

	if index != -1:
		select(index)


## Обрабатывает выбор FPS пользователем.
##
## [param index] — индекс выбранного пункта.
func _on_item_selected(index: int) -> void:
	var text1 := get_item_text(index)
	var fps := int(text1.get_slice(" ", 0))

	GlobalSettings.max_fps = fps
	Engine.max_fps = fps
