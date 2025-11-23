extends Node

@export var rec_scene: PackedScene
@export var triangle_scene: PackedScene
@export var spawn_indicator: PackedScene
@export var spawn_delay: float = 2.5

@export var triangle_enabled: bool = true         # можно включить когда захочешь
<<<<<<< HEAD
@export var rec_weight: int = 5
@export var triangle_weight: int = 1

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	
=======
@export var rec_weight: int = 2
@export var triangle_weight: int = 1

>>>>>>> 3cea586b7d62fc6afe81fb11625c8fbf2d382d7d
func get_spawn_pos():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	var directions = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP].map(func(d): return d.rotated(randf_range(0, PI / 2)))
	
	for dir in directions:
		var distance = randi_range(400, 600)
		var spawn_pos = player.global_position + dir * distance
		var ray_params = PhysicsRayQueryParameters2D.create(
			spawn_pos,
			player.global_position
		)
		var ray_hit = get_tree().root.world_2d.direct_space_state.intersect_ray(ray_params)
		if not ray_hit.is_empty():
			continue
		var point_params = PhysicsPointQueryParameters2D.new()
		point_params.position = spawn_pos
		point_params.collide_with_areas = true
		point_params.collide_with_bodies = true
		var point_hit = get_tree().root.world_2d.direct_space_state.intersect_point(point_params)
		if point_hit.is_empty():
			return spawn_pos
	return player.global_position
	
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
		
<<<<<<< HEAD
		await get_tree().create_timer(spawn_delay, false).timeout
=======
		await get_tree().create_timer(spawn_delay).timeout
>>>>>>> 3cea586b7d62fc6afe81fb11625c8fbf2d382d7d
		
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
