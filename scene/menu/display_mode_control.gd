extends CheckButton

@export var display_mode_text: Label

func _on_toggled(toggled_on):
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		display_mode_text.text = "FULLSREEN"
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		display_mode_text.text = "WINDOWED"

func _on_pressed():
	UISoundManager.play_switch()
