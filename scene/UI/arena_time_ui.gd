extends CanvasLayer

@export var arena_time_manager: Node 
@onready var time = %Time


func _process(_delta):
	if arena_time_manager == null:
		return
	var time_elapsed = arena_time_manager.get_time_elapsed()
	time.text = format_timer(time_elapsed)
	
func format_timer(seconds: float):
	var minutes = floor(seconds / 60)
	var remaning_seconds = seconds - (minutes * 60)
	return str(int(minutes)) + ":" + "%02d" % floor(int(remaning_seconds))
