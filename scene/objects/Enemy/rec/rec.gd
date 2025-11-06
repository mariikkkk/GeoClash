extends CharacterBody2D

var max_speed = 70
var max_distance = 1200

@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var rec = $Rec
@onready var health_component = $HealthComponent
func _ready():
	health_component.died.connect(on_died)
	health_component.damaged.connect(_on_damaged)

func flash_hit():
	var tween := create_tween()
	# Сначала делаем яркую вспышку
	tween.tween_property(rec, "modulate", Color(1, 1, 1, 1), 0.05)
	tween.tween_property(rec, "modulate", Color(0, 0, 0, 1), 0.1)
	
func _on_damaged(amount: int) -> void:
	flash_hit()
	audio_stream_player_2d.play()
	
	
func _process(_delta):
	var direction = get_direction_to_player()
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	velocity = max_speed * direction
	if global_position.distance_squared_to(player.global_position) < pow(max_distance,2):
		move_and_slide()

func get_direction_to_player():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player != null:
		return (player.global_position - global_position).normalized()
	return Vector2.ZERO

func on_died():
	queue_free()

	
