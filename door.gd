extends CanvasLayer

@onready var buff_button: Button = $Panel/Button
@onready var stay_button: Button = $Panel/Button2
@onready var player: Node = null

func _on_buff_pressed() -> void:
	if player:
		player.score -= 1000000
		player.SPEED *= 1.2

		print("Buff applied! SPEED:", player.SPEED, " DAMAGE:", player.DAMAGE, " Score reset.")
	queue_free()

func _on_stay_pressed() -> void:
	print("Chose to stay, keeping score:", player.score if player else "unknown")
	queue_free()

func _ready() -> void:
	player = get_tree().current_scene.find_child("Player", true, false)

	if buff_button:
		buff_button.pressed.connect(_on_buff_pressed)
	if stay_button:
		stay_button.pressed.connect(_on_stay_pressed)
