extends Node

@export var orb_scene: PackedScene
@export var orb_count: int = 3
@export var orbit_radius: float = 60.0
@export var rotation_speed: float = 2.0
@export var orb_damage: int = 1

var _player: Node2D
var _orbs: Array[OrbAttackAbility] = []
var _base_angles: Array[float] = []
var _angle_offset: float = 0.0

func _ready():
	print("ORB CTRL READY")
	print("  player:", get_tree().get_first_node_in_group("player"))
	print("  orb_scene:", orb_scene)
	_player = get_tree().get_first_node_in_group("player") as Node2D
	if _player == null:
		push_warning("Игрок не найден!")
		return
	
	for i in orb_count:
		var orb = orb_scene.instantiate() as OrbAttackAbility
		_player.call_deferred("add_child", orb)
		orb.set_damage(orb_damage)
		print("orb ", i, " parent:", orb.get_parent())
		_orbs.append(orb)
		var base_angle := float(i) / float(orb_count) * TAU
		_base_angles.append(base_angle)
	print("  spawned orbs:", _orbs.size())
	call_deferred("_update_orb_position")
func _process(delta):
	if _player == null:
		return
	_angle_offset += rotation_speed * delta
	_update_orb_position()
	
func _update_orb_position():
	if _player == null:
		return
		
	var center := _player.global_position
	
	for i in _orbs.size():
		var angle := _base_angles[i] + _angle_offset
		var offset := Vector2(cos(angle), sin(angle)) * orbit_radius
		_orbs[i].global_position = center + offset
		_orbs[i].rotation = angle
