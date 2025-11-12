extends Camera2D
@onready var player = $"../player"
@export var shake_amount := 6.0
var t := 0.0
func shake(time := 0.1):
	t = time
func _process(delta):
	if player == null:
		return
	if t > 0.0:
		t -= delta
		offset = Vector2(randf() - 0.5, randf() - 0.5) * shake_amount
	else:
		offset = Vector2.ZERO
	global_position = player.global_position
