extends Node2D

@export var next_scene: String = "res://main_menu.tscn"
@export var display_time: float = 1.5   # how long logo stays fully visible
@export var fade_time: float = 1.0      # how long fade in/out lasts

@onready var logos = $LogoContainer.get_children()  # [Logo1, Logo2, Logo3]

func _ready() -> void:
	# start all logos invisible
	for logo in logos:
		logo.modulate.a = 0.0
	
	# play slideshow
	_play_sequence()

func _play_sequence() -> void:
	for logo in logos:
		await _show_logo(logo)
	# after all → go to main menu
	get_tree().change_scene_to_file(next_scene)

func _show_logo(logo: TextureRect) -> void:
	# fade in
	await _fade_logo(logo, 0.0, 1.0, fade_time)
	# hold visible
	await get_tree().create_timer(display_time).timeout
	# fade out
	await _fade_logo(logo, 1.0, 0.0, fade_time)

func _fade_logo(logo: TextureRect, start_a: float, end_a: float, duration: float) -> void:
	var tween = create_tween()
	logo.modulate.a = start_a
	tween.tween_property(logo, "modulate:a", end_a, duration)
	await tween.finished
