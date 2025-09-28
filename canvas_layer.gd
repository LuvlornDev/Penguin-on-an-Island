extends CanvasLayer

var waiting_for_input := false
@export var fade_duration := 1.0

func _ready():
	$Label.hide()
	$Label2.hide()
	$ColorRect.hide()  # optional

func show_end_screen(score):
	$Label.text = "Score: %d" % score
	$Label2.text = "Press Enter to continue"
	$Label.show()
	$Label2.show()
	waiting_for_input = true

func _process(delta):
	if waiting_for_input and Input.is_action_just_pressed("ui_accept"):
		waiting_for_input = false
		fade_out_and_continue()

func fade_out_and_continue():
	$ColorRect.show()
	$ColorRect.modulate = Color(0,0,0,0)
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate:a", 1.0, fade_duration)
	tween.tween_callback(Callable(self, "_load_credits"))

func _load_credits():
	get_tree().change_scene_to_file("res://credits.tscn")
