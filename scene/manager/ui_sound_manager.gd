extends Node
@onready var click_button = $ClickButton
@onready var hover_button = $HoverButton
@onready var switch_button = $SwitchButton

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func play_hover():
	hover_button.play()
	
func play_click():
	click_button.play()

func play_switch():
	switch_button.play()
