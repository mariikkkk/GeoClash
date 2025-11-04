extends Node

@export var rec_scene: PackedScene
@export var triangle_scene: PackedScene
@export var spawn_indicator: PackedScene
@export var spawn_delay: float = 2.5

@export var triangle_enabled: bool = false         # можно включить когда захочешь
@export var rec_weight: int = 2
@export var triangle_weight: int = 1

func get_spawn_pos():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	var directions = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP].map(func(d): return d.rotated(randf_range(0, PI / 2)))
	
	for dir in directions:
		var distance = randi_range(200, 300)
		var spawn_pos = player.global_position + dir * distance
		var ray_params = PhysicsRayQueryParameters2D.create(spawn_pos, player.global_position)
		var intersection = get_tree().root.world_2d.direct_space_state.intersect_ray(ray_params)
		if intersection.is_empty():
			return spawn_pos
	return player.global_position + Vector2.UP * 300
	
func _on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	else:	
		var pos = get_spawn_pos()
		if spawn_indicator:
			var indicator = spawn_indicator.instantiate() as Node2D
			get_parent().add_child(indicator)
			indicator.global_position = pos
		
		await get_tree().create_timer(spawn_delay).timeout
		
		var scene =  _pick_enemy_scene()
		if scene == null:
			return
		
		var enemy = scene.instantiate() as Node2D
		get_parent().add_child(enemy)
		enemy.global_position = pos

func _pick_enemy_scene():
	var pool: Array[PackedScene] = []
	
	if rec_scene and rec_weight > 0:
		for i in range(rec_weight):
			pool.append(rec_scene)
	if triangle_enabled and triangle_scene and triangle_weight > 0:
		for i in range(triangle_weight):
			pool.append(triangle_scene)
	if pool.is_empty():
		return rec_scene
	return pool.pick_random()
