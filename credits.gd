extends Node2D

@export var hold_required: float = 3
@onready var video: VideoStreamPlayer = $VideoStreamPlayer
@onready var skip_label: Label = $CanvasLayer/UIRoot/SkipLabel
@onready var anim: AnimationPlayer = $AnimationPlayer

var skip_time: float = 0.0
var skipping: bool = false

func _ready() -> void:
	print("Cutscene ready. Hold Enter to skip.")
	video.play()
	if not video.is_connected("finished", Callable(self, "_on_video_finished")):
		video.finished.connect(_on_video_finished)

	# Start idle fade animation
	_reset_skip_label()

func _process(delta: float) -> void:
	if Input.is_action_pressed("skip"):
		# Stop idle animation only once when key is first held
		if anim and anim.is_playing() and anim.current_animation == "skip_label_idle":
			anim.stop()
			skip_label.modulate = Color(1, 1, 1, 1) # fully visible

		skip_time += delta
		var remaining: float = max(0.0, hold_required - skip_time)
		skip_label.text = "Hold ENTER to go to the main menu (" + str(ceil(int(remaining)+1)) + "s)"
		if skip_time >= hold_required and not skipping:
			skipping = true
			_do_skip()
	else:
		if skip_time != 0.0:
			skip_time = 0.0
			_reset_skip_label()

func _reset_skip_label() -> void:
	# Reset text and restart idle fade
	skip_label.text = 'Hold ENTER to go to the main menu'
	if anim and anim.has_animation("skip_label_idle"):
		anim.play("skip_label_idle")

func _on_video_finished() -> void:
	_goto_menu()

func _do_skip() -> void:
	if video.is_playing():
		video.stop()
	if anim and anim.has_animation("fade_out"):
		anim.play("fade_out")
		await anim.animation_finished
		_goto_menu()
	else:
		_goto_menu()

func _goto_menu() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
