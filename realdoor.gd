extends Area2D

@export var menu_scene: PackedScene   # Drag your UpgradeMenu.tscn here in Inspector

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("good"):  # Player is in group "good"
		if menu_scene:
			var menu = menu_scene.instantiate()
			get_tree().current_scene.add_child(menu)
