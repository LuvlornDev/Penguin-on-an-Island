extends Area2D

signal boundary_touched

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "Player":  # Replace with your player node name
		emit_signal("boundary_touched")
		monitoring = false  # prevent retrigger
