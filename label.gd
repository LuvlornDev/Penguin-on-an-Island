# Attach to Label
extends Label

var t := 0.0

func _process(delta):
	t += delta
	modulate.a = 0.5 + 0.5 * sin(t * 3.0)  # fades in/out
