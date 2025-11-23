extends GutTest

var HealthComponent = preload("res://scene/components/health_component.gd")

func _make_hc(max_health := 10.0) -> HealthComponent:
	var root := Node2D.new()
	add_child_autofree(root)
	root.name = "DummyOwner"

	var hc := HealthComponent.new()
	hc.max_health = max_health
	root.add_child(hc)
	await get_tree().process_frame  # дождаться _ready
	return hc

func test_damage_decreases_health():
	var hc := await _make_hc(10)
	watch_signals(hc)

	hc.take_damage(3)
	assert_eq(hc.current_health, 7.0, "HP должно уменьшиться на 3")
	assert_signal_emitted(hc, "health_changed")
	assert_signal_not_emitted(hc, "died")

func test_damage_does_not_go_below_zero_and_emits_died_once():
	var hc := await _make_hc(2)
	watch_signals(hc)

	hc.take_damage(5)
	# check_death вызывается отложенно → подождём кадр
	await get_tree().process_frame

	assert_eq(hc.current_health, 0.0, "HP не должно идти ниже 0")
	assert_signal_emitted(hc, "health_changed")
	assert_signal_emitted(hc, "died")

func test_parametrized_damage_set():
	var cases = [0, 1, 5, 10]
	for dmg in cases:
		var hc := await _make_hc(10)
		hc.take_damage(dmg)
		await get_tree().process_frame
		var expected = max(10 - dmg, 0)
		assert_eq(hc.current_health, float(expected), "Провал на уроне %s" % dmg)

func test_on_level_up_restores_and_increases_max():
	var hc := await _make_hc(5)
	hc.take_damage(3)
	assert_eq(hc.current_health, 2.0)

	hc.on_level_up(2)  # уровень не важен
	assert_eq(hc.max_health, 6.0, "max_health +1")
	assert_eq(hc.current_health, 6.0, "полное восстановление HP")
