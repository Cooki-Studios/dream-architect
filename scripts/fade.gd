extends ColorRect


func fade_to_black(duration := 0.6, x := 0.5, y := 0.5):
	await _fade(1.0, duration, x, y)


func unfade(duration := 0.6, x := 0.5, y := 0.5):
	await _fade(0.0, duration, x, y)


func _fade(target: float, duration := 0.6, x := 0.5, y := 0.5):
	var mat := material as ShaderMaterial
	mat.set_shader_parameter("center", Vector2(x, y))
	
	var tween := create_tween()
	tween.tween_property(mat, "shader_parameter/progress", target, duration)
	await tween.finished
